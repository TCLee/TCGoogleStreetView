//
//  UIButton+TCMuseumFloor.h
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

@class TCMuseumFloor;

/**
 * A category on \c UIButton that adds a \c TCMuseumFloor property to 
 * associate with the button.
 */
@interface UIButton (TCMuseumFloor)

/**
 * The \c TCMuseumFloor object describing the museum floor associated with 
 * this button.
 */
@property (nonatomic, strong) TCMuseumFloor *floor;

@end
