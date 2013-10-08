//
//  TCMuseumFloor.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/8/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCMuseumFloor.h"

@implementation TCMuseumFloor

- (id)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    if (self) {
        _name = [properties[@"name"] copy];
        _coordinate = CLLocationCoordinate2DFromDictionary(properties[@"coordinate"]);
        _camera = GMSPanoramaCameraFromDictionary(properties[@"camera"]);
    }
    return self;
}

/**
 * Creates a \c CLLocationCoordinate2D struct from the given dictionary.
 *
 * @param dictionary The \c NSDictionary instance containing the latitude and longitude values.
 *
 * @return A new \c CLLocationCoordinate2D struct.
 */
FOUNDATION_STATIC_INLINE CLLocationCoordinate2D CLLocationCoordinate2DFromDictionary(NSDictionary *dictionary)
{
    return CLLocationCoordinate2DMake([dictionary[@"latitude"] doubleValue],
                                      [dictionary[@"longitude"] doubleValue]);
}

/**
 * Creates a \c GMSPanoramaCamera instance from the given dictionary.
 *
 * @param dictionary The \c NSDictionary instance containing the camera's properties.
 *
 * @return A new \c GMSPanoramaCamera instance.
 */
FOUNDATION_STATIC_INLINE GMSPanoramaCamera *GMSPanoramaCameraFromDictionary(NSDictionary *dictionary)
{
    return [GMSPanoramaCamera cameraWithHeading:[dictionary[@"heading"] floatValue]
                                          pitch:[dictionary[@"pitch"] floatValue]
                                           zoom:[dictionary[@"zoom"] floatValue]
                                            FOV:[dictionary[@"FOV"] floatValue]];
}

@end
