//
//  TCSpeechGuide.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/11/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

@import AVFoundation.AVSpeechSynthesis;

@class TCMuseum;

/**
 * The speech guide for all the museums.
 *
 * Uses iOS 7 \c AVSpeechSynthesizer class to speak the museum's description.
 */
@interface TCSpeechGuide : NSObject <AVSpeechSynthesizerDelegate>

/**
 * The museum that this speech guide is speaking the description for.
 *
 * To begin speech for another museum, send a \c speakForMuseum: 
 * message with the museum.
 */
@property (nonatomic, strong, readonly) TCMuseum *museum;

/**
 * Begins speaking the museum's description immediately. If speech guide is 
 * currently speaking, it will stop its current speech and begins this new one.
 *
 * Attempting to pass in the same museum object that speech guide is
 * currently speaking, will be ignored.
 *
 * @param museum The \c TCMuseum object containing the museum's description.
 */
- (void)speakForMuseum:(TCMuseum *)museum;

/**
 * Stops its current speech immediately. If speech guide is not currently
 * speaking, this method does nothing.
 */
- (void)stopSpeaking;

@end
