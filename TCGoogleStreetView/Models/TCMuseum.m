//
//  TCMuseum.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/29/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCMuseum.h"

@implementation TCMuseum

- (id)initWithProperties:(NSDictionary *)properties
{
    NSParameterAssert(properties);
    
    self = [super init];
    if (self) {
        _name = [properties[@"name"] copy];
        _city = [properties[@"city"] copy];
        _description = [properties[@"description"] copy];
        _speechText = [properties[@"speech"] copy];
        _coordinate = CLLocationCoordinate2DFromDictionary(properties[@"coordinate"]);
        _camera = GMSPanoramaCameraFromDictionary(properties[@"camera"]);
    }
    return self;
}

/**
 * Creates a \b CLLocationCoordinate2D struct from the given dictionary.
 *
 * @param dictionary The \c NSDictionary instance containing the latitude and longitude values.
 *
 * @return A new \b CLLocationCoordinate2D struct.
 */
FOUNDATION_STATIC_INLINE CLLocationCoordinate2D CLLocationCoordinate2DFromDictionary(NSDictionary *dictionary)
{
    return CLLocationCoordinate2DMake([dictionary[@"latitude"] doubleValue],
                                      [dictionary[@"longitude"] doubleValue]);
}

/**
 * <#Description#>
 *
 * @param dictionary <#dictionary description#>
 *
 * @return <#return value description#>
 */
FOUNDATION_STATIC_INLINE GMSPanoramaCamera *GMSPanoramaCameraFromDictionary(NSDictionary *dictionary)
{
    return [GMSPanoramaCamera cameraWithHeading:[dictionary[@"heading"] floatValue]
                                          pitch:[dictionary[@"pitch"] floatValue]
                                           zoom:[dictionary[@"zoom"] floatValue]
                                            FOV:[dictionary[@"FOV"] floatValue]];
}

@end
