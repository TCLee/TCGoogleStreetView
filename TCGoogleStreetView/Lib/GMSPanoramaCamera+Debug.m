//
//  GMSPanoramaCamera+Debug.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/26/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "GMSPanoramaCamera+Debug.h"

@implementation GMSPanoramaCamera (Debug)

#pragma mark - Description

- (NSString *)description
{
    NSMutableString *description = [[NSMutableString alloc] init];
    
    [description appendFormat:@"GMSPanoramaCamera <%p>\n", (void *)self];
    [description appendString:@"{\n"];
    [description appendFormat:@"  heading: %@,\n", [@(self.orientation.heading) stringValue]];
    [description appendFormat:@"  pitch: %@,\n", [@(self.orientation.pitch) stringValue]];
    [description appendFormat:@"  zoom: %@,\n", [@(self.zoom) stringValue]];
    [description appendFormat:@"  FOV: %@,\n", [@(self.FOV) stringValue]];
    [description appendString:@"}\n"];
    
    return [description copy];
}

#pragma mark - Equality

- (BOOL)isEqualToPanoramaCamera:(GMSPanoramaCamera *)anotherCamera
{
    if (nil == anotherCamera) { return NO; }
    if (self == anotherCamera) { return YES; }
    
    return (self.FOV == anotherCamera.FOV &&
            self.zoom == anotherCamera.zoom &&
            self.orientation.heading == anotherCamera.orientation.heading &&
            self.orientation.pitch == anotherCamera.orientation.pitch);
}

@end
