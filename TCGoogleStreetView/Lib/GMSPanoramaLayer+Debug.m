//
//  GMSPanoramaLayer+Debug.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/4/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "GMSPanoramaLayer+Debug.h"

@implementation GMSPanoramaLayer (Debug)

- (NSString *)description
{
    NSMutableString *description = [[NSMutableString alloc] init];
    
    [description appendFormat:@"GMSPanoramaLayer <%p>\n", (void *)self];
    [description appendString:@"{\n"];
    [description appendFormat:@"  cameraHeading: %@,\n", [@(self.cameraHeading) stringValue]];
    [description appendFormat:@"  cameraPitch: %@,\n", [@(self.cameraPitch) stringValue]];
    [description appendFormat:@"  cameraZoom: %@,\n", [@(self.cameraZoom) stringValue]];
    [description appendFormat:@"  cameraFOV: %@,\n", [@(self.cameraFOV) stringValue]];
    [description appendFormat:@"  animationKeys: %@,\n", self.animationKeys];
    [description appendString:@"}\n"];
    
    return [description copy];
}

@end
