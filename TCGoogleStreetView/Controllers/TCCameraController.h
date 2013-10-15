//
//  TCCameraController.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/13/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

/**
 * The \c TCCameraController class controls the camera of a 
 * \c GMSPanoramaView.
 */
@interface TCCameraController : NSObject

/**
 * Initializes the camera controller with the panorama view that it will 
 * be controlling the camera for.
 *
 * @param panoramaView The \c GMSPanoramaView instance.
 *
 * @return An initialized \c TCCameraController object.
 */
- (id)initWithPanoramaView:(GMSPanoramaView *)panoramaView;

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
- (void)startCameraRotation;

/**
 * Stops the camera heading rotation animation.
 */
- (void)stopCameraRotation;

/**
 * Pauses the camera heading rotation animation.
 *
 * @see https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/AdvancedAnimationTricks/AdvancedAnimationTricks.html#//apple_ref/doc/uid/TP40004514-CH8-SW15
 * @see http://stackoverflow.com/a/10084306
 */
- (void)pauseCameraRotation;

/**
 * Resumes the camera heading rotation animation from when it was paused.
 *
 * @see https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/AdvancedAnimationTricks/AdvancedAnimationTricks.html#//apple_ref/doc/uid/TP40004514-CH8-SW15
 * @see http://stackoverflow.com/a/10084306
 */
- (void)resumeCameraRotation;

@end
