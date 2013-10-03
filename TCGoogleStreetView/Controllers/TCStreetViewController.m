//
//  TCStreetViewController.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

// Text-to-Speech framework
@import AVFoundation.AVSpeechSynthesis;

// Asynchronously load and cache the Google Static Maps images.
#import <SDWebImage/UIImageView+WebCache.h>

#import "TCStreetViewController.h"
#import "TCMuseumDataController.h"
#import "TCMuseum.h"
#import "TCStaticMap.h"

#import "UIAlertView+NSErrorAdditions.h"
#import "GMSPanorama+Debug.h"
#import "GMSPanoramaCamera+Debug.h"

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

@end

@implementation TCStreetViewController

#pragma mark - Views

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAssert(self.dataController, @"TCMuseumDataController must be provided for TCStreetViewController to access the TCMuseum model objects.");
    
    // We have to create the GMSPanoramaView programatically because
    // Google Maps SDK require that we call the initWithFrame: method.
    [self createPanoramaView];
    
    // Show the street view for the first museum in the collection.
    [self updateViewWithMuseum:[self.dataController firstMuseum]];
}

/**
 * Create the panorama view and add it as a subview to the controller's view.
 * If panorama view has already been created, then it does nothing.
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
    self.panoramaView.camera = museum.camera;
    
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
    
    [self.activityIndicator startAnimating];
    self.mapImageView.alpha = 0.0f;
    
    // Load the static map's image asynchronously.
    [self.mapImageView setImageWithURL:museum.map.imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [self.activityIndicator stopAnimating];
        
        [UIView animateWithDuration:1.0f animations:^{
            self.mapImageView.alpha = 1.0f;
        }];
        
        if (!image) {
            UIAlertView *alertView = [UIAlertView alertWithError:error];
            [alertView show];
        }
    }];
}

#pragma mark - GMSPanoramaViewDelegate

- (void)panoramaView:(GMSPanoramaView *)view didMoveToPanorama:(GMSPanorama *)panorama nearCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"Did Move To Panorama:\n%@", panorama);
    
    // Once the panorama view is available, we will start the talking tour guide.
//    [self startSpeechGuideWithMuseum:[self.dataController currentMuseum]];
}

- (void) panoramaView:(GMSPanoramaView *)view error:(NSError *)error onMoveNearCoordinate:(CLLocationCoordinate2D)coordinate
{
    UIAlertView *alertView = [UIAlertView alertWithError:error];
    [alertView show];
}

// This is invoked every time the view.panorama property changes.
- (void)panoramaView:(GMSPanoramaView *)view didMoveToPanorama:(GMSPanorama *)panorama
{
    NSLog(@"Did Move To Panorama:\n%@", panorama);
}

// Called when moveToPanoramaID: produces an error.
- (void)panoramaView:(GMSPanoramaView *)view error:(NSError *)error onMoveToPanoramaID:(NSString *)panoramaID
{
    UIAlertView *alertView = [UIAlertView alertWithError:error];
    [alertView show];
}

// Called repeatedly during changes to the camera on GMSPanoramaView.
- (void)panoramaView:(GMSPanoramaView *)panoramaView didMoveCamera:(GMSPanoramaCamera *)camera
{
    NSLog(@"Did Move Camera: %@", camera);
}

#pragma mark - AVSpeechSynthesis

- (void)startSpeechGuideWithMuseum:(TCMuseum *)museum
{
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:museum.speechText];
    utterance.rate = 0.2; // Min = 0.0, Default = 0.5, Max = 1.0
    [synthesizer speakUtterance:utterance];
}

#pragma mark - IBAction

- (IBAction)nextMuseum:(id)sender
{
    [self updateViewWithMuseum:[self.dataController nextMuseum]];
}

- (IBAction)previousMuseum:(id)sender
{
    [self updateViewWithMuseum:[self.dataController previousMuseum]];
}

@end
