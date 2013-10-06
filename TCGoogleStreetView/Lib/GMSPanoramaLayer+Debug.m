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
    [description appendFormat:@"  kGMSLayerPanoramaHeadingKey: \"%@\",\n", kGMSLayerPanoramaHeadingKey];
    [description appendFormat:@"  kGMSLayerPanoramaPitchKey: \"%@\",\n", kGMSLayerPanoramaPitchKey];
    [description appendFormat:@"  kGMSLayerPanoramaZoomKey: \"%@\",\n", kGMSLayerPanoramaZoomKey];
    [description appendFormat:@"  kGMSLayerPanoramaFOVKey: \"%@\",\n\n", kGMSLayerPanoramaFOVKey];
    
    [description appendFormat:@"  cameraHeading: %@,\n", [@(self.cameraHeading) stringValue]];
    [description appendFormat:@"  cameraPitch: %@,\n", [@(self.cameraPitch) stringValue]];
    [description appendFormat:@"  cameraZoom: %@,\n", [@(self.cameraZoom) stringValue]];
    [description appendFormat:@"  cameraFOV: %@,\n\n", [@(self.cameraFOV) stringValue]];

    [description appendFormat:@"  position: %@,\n", NSStringFromCGPoint(self.position)];
    [description appendFormat:@"  bounds: %@,\n", NSStringFromCGRect(self.bounds)];
    [description appendFormat:@"  anchorPoint: %@,\n", NSStringFromCGPoint(self.anchorPoint)];
    [description appendFormat:@"  opaque: %@,\n", self.opaque ? @"YES" : @"NO"];
    [description appendFormat:@"  animationKeys: %@,\n", self.animationKeys];
    [description appendFormat:@"  actions: %@,\n", self.actions];
    [description appendFormat:@"  style: %@,\n", self.style];
    [description appendString:@"}\n"];
    
    return [description copy];
}

@end
