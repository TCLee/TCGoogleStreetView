//
//  TCStaticMap.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/1/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

/**
 * \c TCStaticMap represents a request to the Google Static Maps API.
 */
@interface TCStaticMap : NSObject

/**
 * The location of the marker on the map. The location is specified as
 * \c {latitude, \c longitude} values.
 */
@property (nonatomic, assign) CLLocationCoordinate2D markerLocation;

/**
 * The zoom level of the map, which determines the magnification level 
 * of the map.
 */
@property (nonatomic, assign) NSUInteger zoom;

/**
 * The rectangular dimensions of the map image.
 *
 * The actual size of the image may be bigger due to the device 
 * screen's scale factor. For example, on Retina displays, the image
 * returned will be 2 * \c size.
 */
@property (nonatomic, assign) CGSize size;

/**
 * Initializes a static map with the given parameters.
 *
 * @param coordinate The \c CLLocationCoordinate2D value representing the marker's location on the map.
 * @param zoom       The \c zoom level of the map.
 * @param size       The rectangular dimensions of the map image.
 *
 * @return An \c TCStaticMap object initialized with the given parameters.
 */
- (id)initWithMarkerLocation:(CLLocationCoordinate2D)coordinate
                        zoom:(NSUInteger)zoom
                        size:(CGSize)size;

/**
 * Returns the URL that can be used to send a request to Google Static Maps API
 * to get the map image.
 *
 * @return The URL for the Google Static Maps API request.
 */
- (NSURL *)imageURL;

@end
