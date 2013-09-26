//
//  UIAlertView+NSErrorAdditions.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/25/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "UIAlertView+NSErrorAdditions.h"

@implementation UIAlertView (NSErrorAdditions)

+ (instancetype)alertWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                        message:[error localizedRecoverySuggestion]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK Button")
                                              otherButtonTitles:nil];

    // Add the recovery options as other buttons after the Cancel button.
    for (NSString *recoveryOption in [error localizedRecoveryOptions]) {
        [alertView addButtonWithTitle:recoveryOption];
    }
    
    return alertView;
}

@end
