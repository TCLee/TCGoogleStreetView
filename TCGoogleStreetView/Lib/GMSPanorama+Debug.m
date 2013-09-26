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
    
    [description appendString:@"GMSPanorama\n"];
    [description appendString:@"{\n"];
    [description appendFormat:@"  panoramaID: %@,\n", self.panoramaID];
    [description appendFormat:@"  coordinate: %@\n", NSStringFromCLLocationCoordinate2D(self.coordinate)];
    [description appendString:@"}\n"];
    
    return [description copy];
}

/** 
 * Returns a NSString from the given CLLocationCoordinate2D values.
 */
FOUNDATION_STATIC_INLINE NSString *NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coordinate)
{
    // We convert the coordinate's latitude and longitude to NSNumber instances
    // because we want to have the same number of decimal points as the actual
    // double value.
    return [NSString stringWithFormat:@"%@, %@",
            [@(coordinate.latitude) stringValue],
            [@(coordinate.longitude) stringValue]];
}

@end
