//
//  TCStaticMap.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/1/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCStaticMap.h"

static NSString * const kTCStaticMapsAPIBaseURLString = @"http://maps.googleapis.com/maps/api/staticmap";

@implementation TCStaticMap

- (id)initWithMarkerLocation:(CLLocationCoordinate2D)coordinate
                        zoom:(NSUInteger)zoom
                        size:(CGSize)size
{
    return nil;
}

- (NSURL *)imageURL
{
    return [NSURL URLWithString:kTCStaticMapsAPIBaseURLString];
}

@end
