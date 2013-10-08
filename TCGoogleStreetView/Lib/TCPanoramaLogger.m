//
//  TCPanoramaLogger.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/8/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCPanoramaLogger.h"

@interface TCPanoramaLogger ()

@property (nonatomic, strong, readonly) GMSPanoramaService *panoramaService;

@end

@implementation TCPanoramaLogger

@synthesize panoramaService = _panoramaService;

- (GMSPanoramaService *)panoramaService
{
    if (!_panoramaService) {
        _panoramaService = [[GMSPanoramaService alloc] init];
    }
    return _panoramaService;
}

- (void)logCoordinatesWithPanoramaIDs:(NSArray *)panoramaIDList
{
    for (NSString *panoramaID in panoramaIDList) {
        [self logCoordinateWithPanoramaID:panoramaID];
    }
}

- (void)logCoordinateWithPanoramaID:(NSString *)panoramaID
{
    [self.panoramaService requestPanoramaWithID:panoramaID callback:^(GMSPanorama *panorama, NSError *error) {
        if (panorama) {
            NSLog(@"%@", [self stringFromPanorama:panorama]);
        } else {
            NSLog(@"GMSPanoramaService Error: %@", [error localizedDescription]);
        }
    }];
}

- (NSString *)stringFromPanorama:(GMSPanorama *)panorama
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    [string appendString:@"\nGMSPanorama\n"];
    [string appendString:@"{\n"];
    [string appendFormat:@"  panoramaID: %@,\n", panorama.panoramaID];
    [string appendFormat:@"  coordinate: %@, %@\n", @(panorama.coordinate.latitude), @(panorama.coordinate.longitude)];
    [string appendString:@"}\n"];
    
    return [string copy];
}

@end
