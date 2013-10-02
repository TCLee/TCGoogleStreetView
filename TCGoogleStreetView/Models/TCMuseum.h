//
//  TCMuseum.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/29/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

@import Foundation;

@class TCStaticMap;

/**
 * The model class to represent a museum.
 */
@interface TCMuseum : NSObject

/**
 * The name of the museum.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 * The city that this museum is located at.
 */
@property (nonatomic, copy, readonly) NSString *city;

/**
 * A short description of the museum.
 */
@property (nonatomic, copy, readonly) NSString *text;

/**
 * The text to be spoken. This string is usually similar to the description, but 
 * may differ slightly to assist the text to voice feature.
 */
@property (nonatomic, copy, readonly) NSString *speechText;

/**
 * The exact coordinates of this museum on the map.
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;

/**
 * The initial camera position for the panorama view.
 */
@property (nonatomic, strong, readonly) GMSPanoramaCamera *camera;

/**
 * The static map to visually show where this museum is located.
 * 
 * The static map is represented by an image and does not allow for
 * user interaction.
 */
@property (nonatomic, strong) TCStaticMap *map;

/**
 * Initializes a TCMuseum model object with the properties parsed from 
 * the JSON data.
 *
 * @param properties The dictionary containing a museum's properties
 * @return A TCMuseum object with its properties initialized to the values 
           in the dictionary.
 */
- (id)initWithProperties:(NSDictionary *)properties;

@end
