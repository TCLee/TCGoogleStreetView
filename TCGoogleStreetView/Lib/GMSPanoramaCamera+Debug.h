//
//  GMSPanoramaCamera+Debug.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/26/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface GMSPanoramaCamera (Debug)

/**
 * Returns \b YES if the given \c GMSPanoramaCamera has the same property 
 * values as the receiver; otherwise \b NO.
 *
 * @param anotherCamera The \c GMSPanoramaCamera to compare to the receiver.
 *
 * @return \b YES if the given \c GMSPanoramaCamera has the same property 
 *         values as the receiver; otherwise \b NO.
 */
- (BOOL)isEqualToPanoramaCamera:(GMSPanoramaCamera *)anotherCamera;

@end
