//
//  TCMuseumDataController.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/29/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

@class TCMuseum;

/**
 * The museum data controller manages a collection of TCMuseum model objects.
 */
@interface TCMuseumDataController : NSObject

/**
 * Returns the first museum object in the collection.
 * Also, moves the enumerator to the first museum object.
 */
- (TCMuseum *)firstMuseum;

/**
 * Returns the last museum object in the collection.
 * Also, moves the enumerator to the last museum object.
 */
- (TCMuseum *)lastMuseum;

/**
 * Returns the next museum object in the collection.
 * If we're at the last museum, it will loop back to the first museum.
 */
- (TCMuseum *)nextMuseum;

/**
 * Returns the current museum in the collection.
 */
- (TCMuseum *)currentMuseum;

/**
 * Returns the previous museum in the collection.
 * If we're at the first museum, it will loop back to the last museum.
 */
- (TCMuseum *)previousMuseum;

/**
 * Returns all the museums in the collection as an array.
 */
- (NSArray *)allMuseums;

/**
 * @brief
 * Removes all the museum objects from the collection.
 *
 * @detail
 * This method is automatically called to release resources when there is
 * a memory warning notification. The museum objects will be reloaded and
 * cached again when you attempt to access the collection the next time.
 */
- (void)removeAllMuseums;

/**
 * Initialize the data controller with data from the given URL.
 *
 * @param url The URL of the data.
 *
 * @return An initialized TCMuseumDataController with data from the given URL.
 */
- (id)initWithURL:(NSURL *)url;

@end
