//
//  TCMuseumFloor.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/8/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

/**
 * Describes a single floor in a museum. 
 * A museum can have multiple floors. A floor can only belong to one museum.
 */
@interface TCMuseumFloor : NSObject

/**
 * Returns the display name for the floor (e.g. "G", "B1", "2")
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 * Returns the coordinates that can be used with GMSPanoramaView
 *  \p moveNearCoordinate:
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;

/**
 * Returns the camera position that can be used with a \c GMSPanoramaView.
 */
@property (nonatomic, strong, readonly) GMSPanoramaCamera *camera;

/**
 * Initializes the museum's floor with property values from the given dictionary.
 *
 * @param properties A \c NSDictionary instance containing the museum floor's properties.
 *
 * @return An initialized \c TCMuseumFloor object.
 */
- (id)initWithProperties:(NSDictionary *)properties;

@end
