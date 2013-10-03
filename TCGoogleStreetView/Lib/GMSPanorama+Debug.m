//
//  GMSPanorama+Debug.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/26/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "GMSPanorama+Debug.h"

@implementation GMSPanorama (Debug)

- (NSString *)description
{
    NSMutableString *description = [[NSMutableString alloc] init];
    
    [description appendFormat:@"GMSPanorama <%p>\n", (void *)self];
    [description appendString:@"{\n"];
    [description appendFormat:@"  panoramaID: %@,\n", self.panoramaID];
    [description appendFormat:@"  coordinate: (%@, %@)\n", [@(self.coordinate.latitude) stringValue], [@(self.coordinate.longitude) stringValue]];
    [description appendString:@"}\n"];
    
    return [description copy];
}

@end
