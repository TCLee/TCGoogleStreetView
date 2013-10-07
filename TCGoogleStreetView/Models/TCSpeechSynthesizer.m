//
//  TCSpeechSynthesizer.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/7/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCSpeechSynthesizer.h"

@interface TCSpeechSynthesizer ()

/**
 * The \c AVSpeechSynthesizer that will be used to speak given text.
 * This property is lazily created when it is first accessed.
 */
@property (nonatomic, strong, readonly) AVSpeechSynthesizer *speechSynthesizer;

/**
 * Set to \c YES if \c AVSpeechSynthesizer should stop speaking immediately;
 * \c NO otherwise.
 *
 * @bug \c AVSpeechSynthesizer does not always stop speaking immediately after 
 *      you send a \c stopSpeakingAtBoundary: message. So, we will have to 
 *      attempt to stop it ourselves by checking this flag.
 */
@property (nonatomic, assign) BOOL shouldStopSpeaking;

@end

@implementation TCSpeechSynthesizer

@synthesize speechSynthesizer = _speechSynthesizer;

#pragma mark - Lazily Initialized Properties

- (AVSpeechSynthesizer *)speechSynthesizer
{
    if (!_speechSynthesizer) {
        _speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
        _speechSynthesizer.delegate = self;
    }
    return _speechSynthesizer;
}

#pragma mark - Start and Stop Speech

- (void)startSpeakingWithString:(NSString *)speechText
{
    // Synthesizer is in the middle of a speech, so we stop it first.
    if (self.speechSynthesizer.isSpeaking) {
        [self stopSpeaking];
    }
    
    // We're about to start a new speech, so don't stop the new speech.
    self.shouldStopSpeaking = NO;
    
    // Start a new speech.
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:speechText];
    utterance.rate = 0.15f; // Min = 0.0, Default = 0.5, Max = 1.0
    [self.speechSynthesizer speakUtterance:utterance];
}

- (void)stopSpeaking
{
    self.shouldStopSpeaking = YES;
    
    // Synthesizer has already stopped speaking.
    if (!self.speechSynthesizer.isSpeaking) { return; }
    
    // Tell synthesizer to stop speaking immediately.
    // This message may not always be successful due to a bug in iOS 7.
    [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

#pragma mark - AVSpeechSynthesizerDelegate

// When the synthesizer should stop speaking but has not, we will attempt to
// stop it here. This delegate message is sent once for each unit of speech
// (generally, a word) in the utterance’s text.
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    if (self.shouldStopSpeaking) {
        [self stopSpeaking];
    }
}

@end
