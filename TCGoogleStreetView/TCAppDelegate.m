//
//  TCAppDelegate.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/24/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#import "TCAppDelegate.h"
#import "TCStreetViewController.h"
#import "TCMuseumDataController.h"

// Replace with your own API key generated using Google APIs Console.
static NSString * const kTCGoogleMapsAPIKey = @"AIzaSyAbmPatPdSYWzYNZip_26u3N8fH1NiBMkw";

@implementation TCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:kTCGoogleMapsAPIKey];

    // Create the data controller that manages the model objects and pass it to
    // the initial view controller.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    TCStreetViewController *streetViewController = (TCStreetViewController *)navigationController.topViewController;
    streetViewController.dataController = [[TCMuseumDataController alloc] initWithURL:
                                           [[NSBundle mainBundle] URLForResource:@"GoogleArtProject"
                                                                   withExtension:@"json"]];
    
    return YES;
}

@end
