//
//  TCStreetViewController.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCStreetViewController.h"
#import "UIAlertView+NSErrorAdditions.h"
#import "GMSPanorama+Debug.h"
#import "GMSPanoramaCamera+Debug.h"

@import AVFoundation.AVSpeechSynthesis;

@interface TCStreetViewController ()

@property (nonatomic, strong) GMSPanoramaView *panoramaView;

/// The label that contains the description text to be spoken.
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation TCStreetViewController

#pragma mark - Memory Management

// Dispose of any resources that can be recreated.
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Clear the panorama view's data.
    self.panoramaView.panorama = nil;
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createPanoramaView];

    [self.panoramaView moveNearCoordinate:CLLocationCoordinate2DMake(48.804541, 2.12013)];
    self.panoramaView.camera = [GMSPanoramaCamera cameraWithHeading:21.0f
                                                              pitch:9.0f
                                                               zoom:1.0f
                                                                FOV:75.0f];
}

#pragma mark - GMSPanoramaView

/**
 * Create the panorama view and add it as a subview to the controller's view.
 * If panorama view has already been created, then it does nothing.
 */
- (void)createPanoramaView
{
    // Only create the panorama view once.
    if (self.panoramaView) { return; }
    
    // Do not specify a frame, since we're using auto layout.
    self.panoramaView = [[GMSPanoramaView alloc] initWithFrame:CGRectZero];
    self.panoramaView.navigationLinksHidden = YES;
    self.panoramaView.streetNamesHidden = YES;
    self.panoramaView.delegate = self;
    
    // Add to the bottom of all other subviews.
    [self.view insertSubview:self.panoramaView atIndex:0];
    
    // Disable this, otherwise we get auto layout constraint conflicts.
    self.panoramaView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add the auto layout constraints for the Panorama View.
    GMSPanoramaView *myPanoramaView = self.panoramaView;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(myPanoramaView);
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[myPanoramaView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[myPanoramaView]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewsDictionary];
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
}

#pragma mark - GMSPanoramaViewDelegate

// Called when the panorama change was caused by invoking moveToPanoramaNearCoordinate:
// The coordinate passed to that method will also be passed here.
- (void)panoramaView:(GMSPanoramaView *)view didMoveToPanorama:(GMSPanorama *)panorama nearCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"Did Move To Panorama:\n%@", panorama);    
}

// Called when moveNearCoordinate: produces an error.
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

// Speech test using Siri's default voice.
- (void)startSpeechGuide
{
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"Versailles was the home of the French monarch from the time of Louis the 14th to Louis the 16th. The palace stands today as an icon of nobility and artistic triumph."];
    utterance.rate = 0.2; // Min = 0.0, Default = 0.5, Max = 1.0
    [synthesizer speakUtterance:utterance];
}

@end
