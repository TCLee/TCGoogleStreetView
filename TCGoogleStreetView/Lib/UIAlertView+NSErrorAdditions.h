//
//  UIAlertView+NSErrorAdditions.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/25/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

@import UIKit;

@interface UIAlertView (NSErrorAdditions)

/**
 * Returns an alert view initialized from information in an error object.
 *
 * @param error Error information to display.
 * @return Initialized alert view.
 */
+ (instancetype)alertWithError:(NSError *)error;

@end
