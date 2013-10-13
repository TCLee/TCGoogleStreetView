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
 * @brief 
 * Speak the given museum's description.
 * 
 * @detail 
 * If speech guide is currently speaking, it will add this request to
 * the queue. Otherwise, it begins speaking immediately.
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

/**
 * Pauses the current speech immediately. If speech guide is not currently 
 * speaking, this method does nothing.
 *
 * To resume the speech from where it was paused, send a \c continueSpeaking
 * message to the speech guide.
 *
 * @see TCSpeechGuide::continueSpeaking
 */
- (void)pauseSpeaking;

/**
 * Continues the speech from the point at which it left off. This method does
 * nothing, if speech guide was not paused previously by calling 
 * \c pauseSpeaking.
 *
 * @see TCSpeechGuide::pauseSpeaking
 */
- (void)continueSpeaking;

@end
