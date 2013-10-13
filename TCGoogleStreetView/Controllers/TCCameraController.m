//
//  TCCameraController.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/13/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCCameraController.h"

@interface TCCameraController ()

/**
 * Reference to the \c GMSPanoramaView layer for easy access.
 *
 * This is a \b weak reference because the \c GMSPanoramaLayer is owned by
 * \c GMSPanoramaView and not this camera controller.
 */
@property (nonatomic, weak) GMSPanoramaLayer *panoramaLayer;

/**
 * The current camera animation running. If animation has stopped, 
 * this property will be \c nil.
 */
@property (nonatomic, copy) CAAnimation *cameraAnimation;

@end

@implementation TCCameraController

- (id)initWithPanoramaView:(GMSPanoramaView *)panoramaView
{
    self = [super init];

    if (self) {
        _panoramaView = panoramaView;
        _panoramaLayer = _panoramaView.layer;
    }

    return self;
}

- (void)startCameraRotation
{
    // The camera headings representing the key frame values in the animation.
    // We move the camera heading by +90 degrees each time, to rotate the
    // camera clockwise. The final camera heading will be the same as the start
    // camera heading.
    CGFloat currentHeading = self.panoramaLayer.cameraHeading;
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
    [self.panoramaLayer addAnimation:animation
                              forKey:kGMSLayerPanoramaHeadingKey];
}

- (void)stopCameraRotation
{
    // Camera animation has stopped, so we should not keep an outdated reference.
    self.cameraAnimation = nil;

    [self.panoramaLayer removeAnimationForKey:kGMSLayerPanoramaHeadingKey];

    // Update the model layer's camera heading with the value from the last frame
    // of the animation before it was stopped. If we don't do this, the camera
    // will jump back to the model layer's camera heading.
    self.panoramaLayer.cameraHeading = [self.panoramaLayer.presentationLayer cameraHeading];
}

- (void)pauseCameraRotation
{
    // When app moves into the background, it automatically removes all
    // animations from the layer. So, we save a copy of the animation object
    // and restore it when camera animation is resumed.
    self.cameraAnimation = [self.panoramaLayer animationForKey:kGMSLayerPanoramaHeadingKey];

    // Pause the camera rotation animation and record the time
    // when it was paused.
    CFTimeInterval pausedTime = [self.panoramaLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.panoramaLayer.speed = 0.0;
    self.panoramaLayer.timeOffset = pausedTime;
}

- (void)resumeCameraRotation
{
    // Using the animation object that we saved when we pause the camera
    // animation, we re-add the animation object back to the layer.
    // This is only needed if the app is moving from the background to the
    // foreground.
    if (self.cameraAnimation &&
        ![self.panoramaLayer animationForKey:kGMSLayerPanoramaHeadingKey]) {

        [self.panoramaLayer addAnimation:self.cameraAnimation
                                  forKey:kGMSLayerPanoramaHeadingKey];
    }

    // Resume the camera rotation animation from the time when it was
    // previously paused.
    CFTimeInterval pausedTime = [self.panoramaLayer timeOffset];
    self.panoramaLayer.speed = 1.0;
    self.panoramaLayer.timeOffset = 0.0;
    self.panoramaLayer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.panoramaLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.panoramaLayer.beginTime = timeSincePause;
}

@end
