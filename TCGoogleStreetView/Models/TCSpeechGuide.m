//
//  TCSpeechGuide.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/11/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCSpeechGuide.h"
#import "TCMuseum.h"

@interface TCSpeechGuide ()

/**
 * The \c AVSpeechSynthesizer that will be used to speak given text.
 * This property is lazily created when it is first accessed.
 */
@property (nonatomic, strong, readonly) AVSpeechSynthesizer *speechSynthesizer;

@end

@implementation TCSpeechGuide

@synthesize speechSynthesizer = _speechSynthesizer;

- (AVSpeechSynthesizer *)speechSynthesizer
{
    if (!_speechSynthesizer) {
        _speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    return _speechSynthesizer;
}

- (void)speakForMuseum:(TCMuseum *)theMuseum
{
    // Ignore if it's the same museum.
    if (_museum == theMuseum) { return; }

    // It's a different museum, so update our speech guide's current museum.
    _museum = theMuseum;

    // Add speech utterance to synthesizer's queue.
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:_museum.speechText];
    utterance.rate = 0.15f; // Min = 0.0, Default = 0.5, Max = 1.0
    [self.speechSynthesizer speakUtterance:utterance];
}

- (void)stopSpeaking
{
    // Synthesizer has already stopped speaking.
    if (!self.speechSynthesizer.isSpeaking) { return; }

    // Stop speaking as soon as possible.
    [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

- (void)pauseSpeaking
{
    // Synthesizer is already paused or stopped speaking.
    if (self.speechSynthesizer.isPaused || !self.speechSynthesizer.isSpeaking) {
        return;
    }

    // Pause speaking as soon as possible.
    [self.speechSynthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

- (void)continueSpeaking
{
    // Synthesizer has not been paused, so there's nothing to resume.
    if (!self.speechSynthesizer.isPaused) { return; }

    [self.speechSynthesizer continueSpeaking];
}

@end
