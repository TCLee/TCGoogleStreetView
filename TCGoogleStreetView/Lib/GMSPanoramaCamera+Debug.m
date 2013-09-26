//
//  GMSPanoramaCamera+Debug.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/26/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "GMSPanoramaCamera+Debug.h"

@implementation GMSPanoramaCamera (Debug)

- (NSString *)description
{
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendString:@"GMSPanoramaCamera\n"];
    [description appendString:@"{\n"];
    [description appendFormat:@"  FOV: %@,\n", [@(self.FOV) stringValue]];
    [description appendFormat:@"  zoom: %@,\n", [@(self.zoom) stringValue]];
    [description appendFormat:@"%@", NSStringFromGMSOrientation(self.orientation)];
    [description appendString:@"}\n"];
    return [description copy];
}

/// Returns a string describing the GMSOrientation struct.
FOUNDATION_STATIC_INLINE NSString *NSStringFromGMSOrientation(GMSOrientation orientation)
{
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendString:@"  orientation:\n"];
    [description appendString:@"  {\n"];
    [description appendFormat:@"    heading: %@,\n", [@(orientation.heading) stringValue]];
    [description appendFormat:@"    pitch: %@\n", [@(orientation.pitch) stringValue]];
    [description appendString:@"  }\n"];
    return [description copy];
}

@end
