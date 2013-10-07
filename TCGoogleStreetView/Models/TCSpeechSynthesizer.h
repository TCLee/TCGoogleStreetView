//
//  TCSpeechSynthesizer.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/7/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

@import Foundation;
@import AVFoundation.AVSpeechSynthesis;

/**
 * The \c TCSpeechSynthesizer class is a thin wrapper over the
 * \c AVSpeechSynthesizer class. This class is created to workaround
 * the issue where [AVSpeechSynthesizer stopSpeakingAtBoundary:]
 * not stopping the speech immediately.
 */
@interface TCSpeechSynthesizer : NSObject <AVSpeechSynthesizerDelegate>

/**
 * Begin speaking the given text immediately.
 * If synthesizer is already speaking, it will stop the previous speech 
 * and starts a new speech with the given text.
 *
 * @param speechText The text to be spoken.
 */
- (void)startSpeakingWithString:(NSString *)speechText;

/**
 * Tells the synthesizer to stop its current speech.
 */
- (void)stopSpeaking;

@end
