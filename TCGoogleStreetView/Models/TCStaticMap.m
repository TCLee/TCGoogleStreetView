//
//  TCStaticMap.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/1/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCStaticMap.h"

NSString * const TCGoogleStaticMapsAPIBaseURLString = @"http://maps.googleapis.com/maps/api/staticmap";

@implementation TCStaticMap

@synthesize imageURL = _imageURL;

- (id)initWithMarkerLocation:(CLLocationCoordinate2D)coordinate
                        zoom:(NSUInteger)zoom
                        size:(CGSize)size
                       scale:(NSUInteger)scale
{
    self = [super init];
    if (self) {
        _markerLocation = coordinate;
        _zoom = zoom;
        _size = size;
        
        // Setter method validates value before setting.
        [self setScale:scale];
    }
    return self;
}

- (void)setScale:(NSUInteger)newScale
{
    // If scale < 1 then scale = 1
    // If scale > 2 then scale = 2
    newScale = MAX(newScale, 1);
    newScale = MIN(newScale, 2);
    
    _scale = newScale;
}

- (NSURL *)imageURL
{
    // If we've already constructed the URL, then we'll just return it.
    if (_imageURL) {
        return _imageURL;
    }
    
    NSMutableString *URLString = [[NSMutableString alloc] initWithFormat:@"%@?center=%@&zoom=%lu&size=%@&scale=%lu&markers=%@&visual_refresh=true&sensor=false",
                                  TCGoogleStaticMapsAPIBaseURLString,
                                  TC_NSStringFromCLLocationCoordinate2D(self.markerLocation),
                                  (unsigned long)self.zoom,
                                  TC_NSStringFromCGSize(self.size),
                                  (unsigned long)self.scale,
                                  TC_NSStringFromCLLocationCoordinate2D(self.markerLocation)];
    
    _imageURL = [[NSURL alloc] initWithString:URLString];
    return _imageURL;
}

/**
 * Returns a string of the format \c "latitude,longitude" from the given \c CLLocationCoordinate2D value.
 *
 * @param coordinate The CLLocationCoordinate2D struct.
 *
 * @return A NSString instance with the format \c "latitude,longitude".
 */
FOUNDATION_STATIC_INLINE NSString *TC_NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coordinate)
{
    return [NSString stringWithFormat:@"%@,%@",
            [@(coordinate.latitude) stringValue],
            [@(coordinate.longitude) stringValue]];
}

/**
 * Returns a string of the format \c "widthxheight" from the given \c CGSize value.
 *
 * @param size The \c CGSize struct.
 *
 * @return A NSString instance with the format \c "widthxheight".
 */
FOUNDATION_STATIC_INLINE NSString *TC_NSStringFromCGSize(CGSize size)
{
    return [NSString stringWithFormat:@"%@x%@",
            [@(size.width) stringValue],
            [@(size.height) stringValue]];
}

@end
