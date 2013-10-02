//
//  TCStaticMap.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/1/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

/**
 * The base URL string of Google Static Maps API.
 */
FOUNDATION_EXPORT NSString * const TCGoogleStaticMapsAPIBaseURLString;

/**
 * \c TCStaticMap represents a request to the Google Static Maps API.
 */
@interface TCStaticMap : NSObject

/**
 * The location of the marker on the map. The location is specified as
 * \c {latitude, \c longitude} values.
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D markerLocation;

/**
 * The zoom level of the map, which determines the magnification level 
 * of the map.
 * Min zoom level is 0 (the entire world can be seen on the map).
 * Max zoom level is dependent on location, as data in some parts of the globe is more granular 
 * than in other locations.
 */
@property (nonatomic, readonly) NSUInteger zoom;

/**
 * The rectangular dimensions of the map image.
 */
@property (nonatomic, readonly) CGSize size;

/**
 * The scale affects the number of pixels that are returned. 
 * For example, \c scale=2 returns twice as many pixels as \c scale=1 while retaining the same
 * coverage area and level of detail (i.e. the contents of the map don't change).
 * The default value is \b 1. Accepted values are \b 1 or \b 2 only.
 */
@property (nonatomic, readonly) NSUInteger scale;

/**
 * Returns the URL that can be used to send a request to Google Static Maps API
 * to get the map image.
 */
@property (nonatomic, readonly) NSURL *imageURL;

/**
 * Initializes a static map with the given parameters.
 *
 * @param coordinate The \c CLLocationCoordinate2D value representing the marker's location on the map.
 * @param zoom       The \c zoom level of the map.
 * @param size       The rectangular dimensions of the map image.
 * @param scale      The scale affects the number of pixels that are returned.
 *
 * @return An \c TCStaticMap object initialized with the given parameters.
 */
- (id)initWithMarkerLocation:(CLLocationCoordinate2D)coordinate
                        zoom:(NSUInteger)zoom
                        size:(CGSize)size
                       scale:(NSUInteger)scale;

- (id)init __attribute__((unavailable("Use initWithMarkerLocation:zoom:size:scale instead.")));

@end
