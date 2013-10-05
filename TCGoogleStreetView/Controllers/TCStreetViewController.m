//
//  TCStreetViewController.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

// Asynchronously load and cache the Google Static Maps images.
#import <SDWebImage/UIImageView+WebCache.h>

#import "TCStreetViewController.h"
#import "TCMuseumDataController.h"
#import "TCMuseum.h"
#import "TCStaticMap.h"

#import "UIAlertView+NSErrorAdditions.h"
#import "GMSPanorama+Debug.h"
#import "GMSPanoramaCamera+Debug.h"
#import "GMSPanoramaLayer+Debug.h"

@interface TCStreetViewController ()

/**
 * A reference to the GMSPanoramaView subview for easy access.
 *
 * The \c panoramaView property is a weak reference because our
 * controller's view owns (strong reference) the \c GMSPanoramaView instance.
 */
@property (nonatomic, weak) GMSPanoramaView *panoramaView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;

/**
 * The \c AVSpeechSynthesizer instance used for the speaking tour guide.
 * We keep a \b strong reference to the \c AVSpeechSynthesizer, so that we
 * can cancel the speech at any time.
 */
@property (nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;

@end

@implementation TCStreetViewController

#pragma mark - Views

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // We have to create the GMSPanoramaView programatically because
    // Google Maps SDK require that we call the initWithFrame: method.
    [self createPanoramaView];
    
    // Show panorama view for the first museum in the list.
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
    
    // Add to the bottom of all other subviews.
    [self.view insertSubview:panoView atIndex:0];
    self.panoramaView = panoView;
    
    // Disable this, otherwise we get auto layout constraint conflicts!
    panoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add the auto layout constraints for the Panorama View.
    // Basically, we specify zero leading, trailing, top and bottom space to the superview.
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(panoView);
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[panoView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[panoView]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewsDictionary];
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
}

/**
 * Updates the views to reflect the details of the given museum model object.
 *
 * @param museum The \c TCMuseum model object containing the data for the views.
 */
- (void)updateViewWithMuseum:(TCMuseum *)museum
{
    [self.panoramaView moveNearCoordinate:museum.coordinate];
    
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
        museum.map = [[TCStaticMap alloc] initWithMarkerLocation:museum.coordinate
                                                            zoom:12
                                                            size:self.mapImageView.bounds.size
                                                           scale:[[UIScreen mainScreen] scale]];
    }
    
    // Show activity indicator while map image is fetched from Google's servers.
    // When map image is ready it will smoothly fade in.
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

#pragma mark - GMSPanoramaViewDelegate

/**
 * Called when the panorama change was caused by invoking
 * moveToPanoramaNearCoordinate:. The coordinate passed to that method will also
 * be passed here.
 */
- (void)panoramaView:(GMSPanoramaView *)panoramaView didMoveToPanorama:(GMSPanorama *)panorama nearCoordinate:(CLLocationCoordinate2D)coordinate
{
    TCMuseum *museum = [self.dataController currentMuseum];
    
    // Update the camera for this panorama view.
    // Each panorama view will have their own unique camera settings.
    panoramaView.camera = museum.camera;

    // Fade in the panorama view.
    panoramaView.alpha = 0.0f;
    [UIView animateWithDuration:0.8f animations:^{
        panoramaView.alpha = 1.0f;
    }
    completion:^(BOOL finished) {
        // Start the talking tour guide for the current museum.
//        [self startSpeechGuideWithMuseum:museum];
    }];
}

/**
 * Called repeatedly during changes to the camera on GMSPanoramaView. This may
 * not be called for all intermediate camera values, but is always called for
 * the final position of the camera after an animation or gesture.
 */
- (void)panoramaView:(GMSPanoramaView *)panoramaView didMoveCamera:(GMSPanoramaCamera *)camera
{
    // Google Maps SDK will call this delegate method even if there's no
    // panorama data available.
    if (!panoramaView.panorama) {
        return;
    }
    
    NSUInteger finalCameraHeading = floorf(panoramaView.camera.orientation.heading);
    NSUInteger currentCameraHeading = floorf(camera.orientation.heading);
    
    // When we've reached the final position of the camera animation, we
    // will start a new rotation animation. Camera rotation animation never
    // stops until user takes over.
    if (currentCameraHeading == finalCameraHeading) {
        [panoramaView updateCamera:[GMSPanoramaCameraUpdate rotateBy:90.0f]
                 animationDuration:13.0f];
    }
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

#pragma mark - Speaking Tour Guide

/**
 * Starts the speaking tour guide for the given museum.
 *
 * @param museum The \c TCMuseum object that contains the speech text for the speaking tour guide.
 */
- (void)startSpeechGuideWithMuseum:(TCMuseum *)museum
{
    // --- Is this an Apple bug? ---
    // Sending a stopSpeaking message does not always stop the speech.
    // Sending a stopSpeaking message AND creating a new AVSpeechSynthesizer
    // instance each time will stop the speech immediately. Go figure.
    
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:museum.speechText];
    utterance.rate = 0.2f; // Min = 0.0, Default = 0.5, Max = 1.0
    [self.speechSynthesizer speakUtterance:utterance];
}

/**
 * Stops the speaking tour guide immediately. This method is called when
 * user navigates to the next or previous museum.
 */
- (void)stopSpeechGuide
{
    if (self.speechSynthesizer.isSpeaking) {
        [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        self.speechSynthesizer = nil;
    }
}

#pragma mark - Museum Collection Navigation

- (IBAction)nextMuseum:(id)sender
{
    [self navigateToMuseum:[self.dataController nextMuseum]];
}

- (IBAction)previousMuseum:(id)sender
{
    [self navigateToMuseum:[self.dataController previousMuseum]];
}

/**
 * Navigates the user to the given museum.
 *
 * @param museum The \c TCMuseum model object to navigate to.
 */
- (void)navigateToMuseum:(TCMuseum *)museum
{
    // Clear the current panorama before moving to the next panorama.
    self.panoramaView.panorama = nil;
    
    // Stop any ongoing camera animations.
    [self.panoramaView.layer removeAllAnimations];
    
    // Stop the speaking tour guide immediately. We will need to prepare
    // the speech for the next museum.
    [self stopSpeechGuide];
    
    [self updateViewWithMuseum:museum];
}

@end
