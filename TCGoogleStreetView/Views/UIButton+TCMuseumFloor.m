//
//  UIButton+TCMuseumFloor.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/9/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "UIButton+TCMuseumFloor.h"
#import "TCMuseumFloor.h"

// Objective-C Runtime: Associative References
@import ObjectiveC.runtime;

/** 
 * Used as the key for the association.
 * It does not have to be initialized, since we only want the 
 * address of the variable, not its contents.
 */
static char TCMuseumFloorPropertyKey;

@implementation UIButton (TCMuseumFloor)

// We cannot use @synthesize in a category implementation.
@dynamic floor;

- (TCMuseumFloor *)floor
{
    return objc_getAssociatedObject(self, &TCMuseumFloorPropertyKey);
}

- (void)setFloor:(TCMuseumFloor *)floor
{
    objc_setAssociatedObject(self, &TCMuseumFloorPropertyKey, floor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
