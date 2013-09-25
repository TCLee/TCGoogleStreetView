//
//  TCAppDelegate.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

// Replace with your own API key generated using Google APIs Console.
static NSString * const kTCGoogleMapsAPIKey = @"AIzaSyAbmPatPdSYWzYNZip_26u3N8fH1NiBMkw";

@implementation TCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // We need the API key to use Google Maps SDK for iOS.
    [GMSServices provideAPIKey:kTCGoogleMapsAPIKey];
    
    return YES;
}

@end
