//
//  TCStreetViewController.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

// Text-to-Speech framework
@import AVFoundation.AVSpeechSynthesis;

#import "TCStreetViewController.h"
#import "TCMuseumDataController.h"
#import "TCMuseum.h"

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

/**
 * The museum currently displayed in the panorama view.
 */
@property (nonatomic, strong) TCMuseum *museum;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;

@end

@implementation TCStreetViewController

#pragma mark - View Events

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAssert(self.dataController, @"TCMuseumDataController must be provided for TCStreetViewController to access the TCMuseum model objects.");
    
    // We have to create the GMSPanoramaView programatically because
    // Google Maps SDK require that we call the initWithFrame: method.
    [self createPanoramaView];
    
    // Show the street view for the first museum in the collection.
    self.museum = [self.dataController firstMuseum];
    [self showPanoramaWithMuseum:self.museum];
}

#pragma mark - GMSPanoramaView

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
 * Updates the \b GMSPanoramaView to show the panorama for the given museum.
 *
 * @param museum The \p TCMuseum object containing the data for the panorama view.
 */
- (void)showPanoramaWithMuseum:(TCMuseum *)museum
{
    [self.panoramaView moveNearCoordinate:museum.coordinate];
    self.panoramaView.camera = museum.camera;
}

#pragma mark - GMSPanoramaViewDelegate

- (void)panoramaView:(GMSPanoramaView *)view didMoveToPanorama:(GMSPanorama *)panorama nearCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"Did Move To Panorama:\n%@", panorama);
    
    // Once the panorama view is available, we will start the talking tour guide.
//    [self startSpeechGuideWithMuseum:self.museum];
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
    self.museum = [self.dataController nextMuseum];
    [self showPanoramaWithMuseum:self.museum];
}

- (IBAction)previousMuseum:(id)sender
{
    self.museum = [self.dataController previousMuseum];
    [self showPanoramaWithMuseum:self.museum];
}

@end
