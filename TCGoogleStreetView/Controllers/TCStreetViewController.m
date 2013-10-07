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

#import "TCStreetViewController.h"
#import "TCMuseumDataController.h"
#import "TCMuseum.h"
#import "TCStaticMap.h"
#import "TCSpeechSynthesizer.h"

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
 * The speech synthesizer that acts as the museum tour guide.
 */
@property (nonatomic, strong, readonly) TCSpeechSynthesizer *speechSynthesizer;

@end

@implementation TCStreetViewController

@synthesize speechSynthesizer = _speechSynthesizer;

- (TCSpeechSynthesizer *)speechSynthesizer
{
    if (!_speechSynthesizer) {
        _speechSynthesizer = [[TCSpeechSynthesizer alloc] init];
    }
    return _speechSynthesizer;
}

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

#pragma mark - GMSPanoramaViewDelegate

/**
 * Called when the panorama change was caused by invoking moveToPanoramaNearCoordinate:. 
 * The coordinate passed to that method will also be passed here.
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
        [self.speechSynthesizer startSpeakingWithString:museum.speechText];
    }];
    
    // Begin camera rotation animation.
    [self rotatePanoramaCamera:panoramaView.camera];
}

- (void)panoramaView:(GMSPanoramaView *)view willMoveToPanoramaID:(NSString *)panoramaID
{
    // When user double taps the screen to navigate around in the panorama,
    // we will stop the camera rotation.
    [self stopCameraRotation];
}

- (void)panoramaView:(GMSPanoramaView *)panoramaView didTap:(CGPoint)point
{
    // When user taps anywhere on the screen, we will stop the camera rotation.
    [self stopCameraRotation];
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

#pragma mark - GMSPanoramaCamera Animations

/**
 * Rotates the given panorama camera's heading by 360 degrees.
 * This camera animation loops forever and can only be interrupted by
 * the user's interaction.
 *
 * @note We are using Core Animation to animate the camera instead of
 * \c GMSPanoramaView built-in animation methods. This gives us more control
 * over each key frame of the camera animation.
 *
 * @param camera The \c GMSPanoramaCamera object to rotate the heading for.
 */
- (void)rotatePanoramaCamera:(GMSPanoramaCamera *)camera
{
    // The camera headings representing the key frame values in the animation.
    // We move the camera heading by +90 degrees each time, to rotate the
    // camera clockwise. The final camera heading will be the same as the start
    // camera heading.
    CGFloat currentHeading = camera.orientation.heading;
    NSArray *cameraHeadings = @[@(currentHeading),
                                @(currentHeading + 90.0f),
                                @(currentHeading + 180.0f),
                                @(currentHeading + 270.0f),
                                @(currentHeading + 360.0f)];
    
    // Create the animation with the cameraHeading property key path.
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:kGMSLayerPanoramaHeadingKey];
    animation.values = cameraHeadings;
    animation.duration = 40.0f;
    animation.repeatCount = HUGE_VALF;
    
    // Add the animation to the layer to begin the animation.
    [self.panoramaView.layer addAnimation:animation forKey:kGMSLayerPanoramaHeadingKey];    
}

/**
 * Stops the panorama view's camera rotation animation immediately.
 */
- (void)stopCameraRotation
{
    [self.panoramaView.layer removeAnimationForKey:kGMSLayerPanoramaHeadingKey];
    
    // Update the model layer's camera heading with the value from the last frame
    // of the animation before it was stopped. If we don't do this, the camera
    // will jump back to the model layer's camera heading.
    self.panoramaView.layer.cameraHeading = [self.panoramaView.layer.presentationLayer cameraHeading];
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
 * Navigates the user to the given museum.
 *
 * @param museum The \c TCMuseum model object to navigate to.
 */
- (void)navigateToMuseum:(TCMuseum *)museum
{
    // Clear the current panorama before moving to the next panorama.
    self.panoramaView.panorama = nil;
    
    [self stopCameraRotation];    
    [self.speechSynthesizer stopSpeaking];
    
    // Update view for the next (or previous) museum.
    [self updateViewWithMuseum:museum];
}

@end
