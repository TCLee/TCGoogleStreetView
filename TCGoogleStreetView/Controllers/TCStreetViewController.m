//
//  TCStreetViewController.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

// Asynchronously load and cache the Google Static Maps images.
#import <SDWebImage/UIImageView+WebCache.h>

// Type generic math library.
// Refer to http://stackoverflow.com/a/1271136
#import <tgmath.h>

#import "UIAlertView+NSErrorAdditions.h"

#import "TCStreetViewController.h"
#import "TCCameraController.h"
#import "TCTouchGestureRecognizer.h"
#import "TCMuseumDataController.h"
#import "TCMuseum.h"
#import "TCMuseumFloor.h"
#import "TCStaticMap.h"
#import "TCSpeechGuide.h"

@interface TCStreetViewController ()

/**
 * A reference to the \c GMSPanoramaView subview for easy access.
 *
 * The \c panoramaView property is a \b weak reference because our
 * controller's view owns (\b strong reference) the \c GMSPanoramaView instance.
 */
@property (nonatomic, weak) GMSPanoramaView *panoramaView;

/**
 * A reference to the \c TCFloorPickerView subview.
 *
 * The \c floorPicker property is a \b weak reference because our controller's 
 * view owns (\b strong reference) the \c TCFloorPickerView instance.
 */
@property (nonatomic, weak) TCFloorPickerView *floorPicker;

/**
 * The speech guide will speak the museum's description text when a 
 * museum's panorama view is displayed.
 */
@property (nonatomic, strong, readonly) TCSpeechGuide *speechGuide;

/**
 * The camera controller that will control the panorama view's camera.
 */
@property (nonatomic, strong, readonly) TCCameraController *cameraController;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;

@end

@implementation TCStreetViewController

@synthesize speechGuide = _speechGuide;
@synthesize cameraController = _cameraController;

#pragma mark - Speech Guide

- (TCSpeechGuide *)speechGuide
{
    if (!_speechGuide) {
        _speechGuide = [[TCSpeechGuide alloc] init];
    }
    return _speechGuide;
}

#pragma mark - Camera Controller

- (TCCameraController *)cameraController
{
    if (!_cameraController) {
        _cameraController = [[TCCameraController alloc]
                             initWithPanoramaView:self.panoramaView];
    }
    return _cameraController;
}

#pragma mark - Memory Management

- (void)dealloc
{
    // Before we're deallocated, we must tell notification center to stop
    // sending us notifications. Otherwise, it will send the next notification
    // to a non-existent object and the program crashes.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - App State Events

/**
 * Register for app state notifications, so that our view controller will
 * be notified when the app moves into the foreground or background.
 */
- (void)registerForAppNotifications
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillEnterForeground:)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];
}

/**
 * App has been moved to the background.
 *
 * @param notification The \c UIApplicationDidEnterBackgroundNotification notification object.
 */
- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    // Pause the speech guide immediately.
    [self.speechGuide pauseSpeaking];

    // We store the camera animation state and pause it when app has moved into
    // the background. This will allow us to resume the camera animations later.
    [self.cameraController pauseCameraRotation];
}

/**
 * App is about to enter the foreground.
 *
 * @param notification The \c UIApplicationWillEnterForegroundNotification notification object.
 */
- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    // Continue speech guide from where she paused talking.
    [self.speechGuide continueSpeaking];

    // We resume camera animations from exactly where we paused.
    [self.cameraController resumeCameraRotation];
}

#pragma mark - Views

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self registerForAppNotifications];
    
    // We have to create the GMSPanoramaView programatically because
    // Google Maps SDK require that we call the initWithFrame: method.
    [self createPanoramaView];

    // Create the floor picker view that will be used to select the floors of
    // a museum. We are creating it programatically because each museum have
    // different number of floors.
    [self createFloorPickerView];
    
    // Show panorama view for the first museum in the collection.
    [self updateViewWithMuseum:[self.dataController firstMuseum]];
}

/**
 * Create the panorama view and add it as a subview to the controller's view.
 */
- (void)createPanoramaView
{
    // The frame does not matter, since we're using auto layout.
    GMSPanoramaView *panoView = [[GMSPanoramaView alloc] initWithFrame:CGRectZero];
    panoView.navigationLinksHidden = YES;
    panoView.streetNamesHidden = YES;
    panoView.delegate = self;
    
    // Add panorama view below all the other subviews.
    [self.view insertSubview:panoView atIndex:0];
    self.panoramaView = panoView;

    // When user touches the panorama view, we will stop the camera animation.
    // This is to prevent the camera animation from getting in the way of the user.
    TCTouchGestureRecognizer *touchRecognizer =
        [[TCTouchGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(stopCameraAnimationOnGesture:)];
    touchRecognizer.delegate = self;
    [panoView addGestureRecognizer:touchRecognizer];

    // Pin the panorama view on all sides to the superview.
    [self setupConstraintsForPanoramaView:panoView];
}

/**
 * Create the layout constraints to pin the given panorama view on all sides 
 * to its superview.
 *
 * @param panoView The \c panorama view to setup the layout constraints for.
 */
- (void)setupConstraintsForPanoramaView:(GMSPanoramaView *)panoView
{
    // Disable this, otherwise we get auto layout constraint conflicts.
    panoView.translatesAutoresizingMaskIntoConstraints = NO;

    // The panorama view is pinned on all sides to its superview.
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(panoView);
    [panoView.superview addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[panoView]|"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]];
    [panoView.superview addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[panoView]|"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]];
}

/**
 * Create the floor picker view and add it as a subview to the controller's view.
 * The floor picker view will update accordingly to match the number of floors in
 * the currently displayed museum.
 */
- (void)createFloorPickerView
{
    TCFloorPickerView *floorPicker = [[TCFloorPickerView alloc] initWithDelegate:self];
    [self.view addSubview:floorPicker];
    self.floorPicker = floorPicker;

    id topGuide = self.topLayoutGuide;
    NSDictionary *metricsDictionary = @{@"horizontalPadding": @20,
                                        @"verticalPadding": @20};
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(topGuide, floorPicker);

    // Pin the floor picker view at the Top Right corner with the given
    // horizontal and vertical padding.
    // The floor picker view will calculate its own size from its subviews.
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[floorPicker]-horizontalPadding-|"
                                             options:0
                                             metrics:metricsDictionary
                                               views:viewsDictionary]];
    // Note: We're using [topGuide] and not superview '|'.
    // If we added a constraint relationship to the superview instead,
    // the floor picker view will end up under the navigation bar.
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-verticalPadding-[floorPicker]"
                                             options:0
                                             metrics:metricsDictionary
                                               views:viewsDictionary]];
}

/**
 * Updates the views to reflect the details of the given museum model object.
 *
 * @param museum The \c TCMuseum model object containing the data for the views.
 */
- (void)updateViewWithMuseum:(TCMuseum *)museum
{
    // Set floor picker to control the floors for the given museum.
    self.floorPicker.museum = museum;

    self.titleLabel.text = museum.name;
    self.cityLabel.text = museum.city;
    self.descriptionLabel.text = museum.text;
    
    [self showMapImageWithMuseum:museum];
}

/**
 * Shows the map for the given museum on the image view.
 *
 * @param museum The \c TCMuseum object to show the map for.
 */
- (void)showMapImageWithMuseum:(TCMuseum *)museum
{
    // Create the static map for the museum, if it does not exist yet.
    if (!museum.map) {
        museum.map = [[TCStaticMap alloc] initWithMarkerLocation:museum.defaultFloor.coordinate
                                                            zoom:12
                                                            size:self.mapImageView.bounds.size
                                                           scale:[[UIScreen mainScreen] scale]];
    }
    
    // Show activity indicator while map image is fetched from Google's servers.
    // When map image is ready, it will smoothly fade in.
    [self.activityIndicator startAnimating];
    self.mapImageView.alpha = 0.0f;
    
    // Load the static map's image asynchronously.
    [self.mapImageView setImageWithURL:museum.map.imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [self.activityIndicator stopAnimating];
        [UIView animateWithDuration:0.8f animations:^{
            self.mapImageView.alpha = 1.0f;
        }];
        
        if (!image) {
            UIAlertView *alertView = [UIAlertView alertWithError:error];
            [alertView show];
        }
    }];
}

#pragma mark - Panorama Camera Gestures

/**
 * Stops the camera rotation animation when we recognize user's
 * gestures to manipulate the camera.
 *
 * @param gesture The \c UIGestureRecognizer object that send this
 *                action to our view controller.
 */
- (void)stopCameraAnimationOnGesture:(UIGestureRecognizer *)gesture
{
    // For continuous gestures, as soon as they are first recognized
    // (UIGestureRecognizerStateBegan), we will stop the camera animation
    // immediately. If we wait until UIGestureRecognizerStateEnded,
    // the camera animation will still be running while user attempts to
    // manipulate the camera.

    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.cameraController stopCameraRotation];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // Must return YES to allow simultaneous gesture recognition.
    // Otherwise, our gestures will interfere with GMSPanoramaView's
    // built-in gestures.
    return YES;
}

#pragma mark - GMSPanoramaViewDelegate

- (void)panoramaView:(GMSPanoramaView *)panoramaView didMoveToPanorama:(GMSPanorama *)panorama nearCoordinate:(CLLocationCoordinate2D)coordinate
{
    // Each museum floor will have its own ideal camera angle.
    TCMuseumFloor *selectedFloor = self.floorPicker.selectedFloor;
    panoramaView.camera = selectedFloor.camera;

    // Fade in the panorama view.
    panoramaView.alpha = 0.0f;
    [UIView animateWithDuration:0.8f animations:^{
        panoramaView.alpha = 1.0f;
    }
    completion:^(BOOL finished) {
        // Begins speaking museum's description, once the panorama view has
        // faded in.
        [self.speechGuide speakForMuseum:[self.dataController currentMuseum]];
    }];
    
    // Begin camera rotation animation.
    [self.cameraController startCameraRotation];
}

- (void) panoramaView:(GMSPanoramaView *)view error:(NSError *)error onMoveNearCoordinate:(CLLocationCoordinate2D)coordinate
{
    UIAlertView *alertView = [UIAlertView alertWithError:error];
    [alertView show];
}

- (void)panoramaView:(GMSPanoramaView *)view error:(NSError *)error onMoveToPanoramaID:(NSString *)panoramaID
{
    UIAlertView *alertView = [UIAlertView alertWithError:error];
    [alertView show];
}

#pragma mark - Museum Navigation

- (IBAction)nextMuseum:(id)sender
{
    [self navigateToMuseum:[self.dataController nextMuseum]];
}

- (IBAction)previousMuseum:(id)sender
{
    [self navigateToMuseum:[self.dataController previousMuseum]];
}

/**
 * Navigates the user to the new museum.
 *
 * @param museum The \c TCMuseum model object to navigate to.
 */
- (void)navigateToMuseum:(TCMuseum *)museum
{
    // Clear the current panorama before moving to the next museum's panorama.
    self.panoramaView.panorama = nil;

    // Stop the speech guide as soon as possible, otherwise the speech will
    // continue onto the next museum.
    [self.speechGuide stopSpeaking];

    // Stop any ongoing camera rotation animation. The camera position will be
    // set again when next museum's panorama is ready.
    [self.cameraController stopCameraRotation];

    // Update view for the next museum.
    [self updateViewWithMuseum:museum];
}

#pragma mark - TCFloorPickerViewDelegate

- (void)floorPickerView:(TCFloorPickerView *)floorPickerView didSelectFloor:(TCMuseumFloor *)floor
{
    // Stop the current camera rotation animation. The next floor will have
    // its own camera position and angle.
    [self.cameraController stopCameraRotation];

    // Each museum floor have their specific street view coordinates.
    [self.panoramaView moveNearCoordinate:floor.coordinate];
}

@end
