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
 * Returns the first museum in the list.
 */
- (TCMuseum *)firstMuseum;

/**
 * Returns the next museum in the list.
 * If we're at the last museum, it will loop back to the first museum.
 */
- (TCMuseum *)nextMuseum;

/**
 * Returns the previous museum in the list.
 * If we're at the first museum, it will loop back to the last museum.
 */
- (TCMuseum *)previousMuseum;

@end
