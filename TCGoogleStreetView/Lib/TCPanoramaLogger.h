//
//  TCPanoramaLogger.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/8/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

/**
 * \c TCPanoramaLogger is an utility class that contains methods
 * to log panorama coordinates from the given panorama ID list.
 *
 * This is useful for situations when you know only the panorama ID
 * of a panorama, but not the coordinates.
 */
@interface TCPanoramaLogger : NSObject

/**
 * Log the coordinates for the given array of panorama ID strings 
 * to the console.
 *
 * @param panoramaIDList The \c NSArray of \c panoramaID strings.
 */
- (void)logCoordinatesWithPanoramaIDs:(NSArray *)panoramaIDList;

/**
 * Log the coordinate of the panorama with the given \c panoramaID.
 *
 * @param panoramaID The unique ID of a Street View panorama.
 */
- (void)logCoordinateWithPanoramaID:(NSString *)panoramaID;

@end
