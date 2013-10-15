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
    [description appendFormat:@"  animationKeys: %@,\n", self.animationKeys];
    [description appendFormat:@"  presentationLayer: %@,\n", [self descriptionForLayer:self.presentationLayer]];
    [description appendFormat:@"  modelLayer: %@,\n", [self descriptionForLayer:self.modelLayer]];
    [description appendString:@"}\n"];
    
    return [description copy];
}

- (NSString *)descriptionForLayer:(GMSPanoramaLayer *)layer
{
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendFormat:@"%@ <%p>\n", NSStringFromClass([layer class]), (void *)layer];
    [description appendString:@"  {\n"];
    [description appendFormat:@"    cameraHeading: %@,\n", [@(layer.cameraHeading) stringValue]];
    [description appendFormat:@"    cameraPitch: %@,\n", [@(layer.cameraPitch) stringValue]];
    [description appendFormat:@"    cameraZoom: %@,\n", [@(layer.cameraZoom) stringValue]];
    [description appendFormat:@"    cameraFOV: %@,\n", [@(layer.cameraFOV) stringValue]];
    [description appendString:@"  }"];
    return [description copy];
}

@end
