//
//  TCMuseum.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/29/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCMuseum.h"
#import "TCMuseumFloor.h"

@implementation TCMuseum

- (id)initWithProperties:(NSDictionary *)properties
{
    TCAssertProperties(properties);
    
    self = [super init];
    if (self) {
        _name = [properties[@"name"] copy];
        _city = [properties[@"city"] copy];
        _text = [properties[@"description"] copy];
        _speechText = [properties[@"speech"] copy];
        _defaultFloorIndex = [properties[@"default_floor"] unsignedIntegerValue];
        _floors = TCMuseumFloorsFromArrayProperty(properties[@"floors"]);
        _defaultFloor = _floors[_defaultFloorIndex];
    }
    return self;
}

/**
 * Asserts that we are given a valid properties dictionary with the 
 * expected keys and values.
 *
 * @param propertiesDict The properties dictionary to assert.
 */
FOUNDATION_STATIC_INLINE void TCAssertProperties(NSDictionary *propertiesDict)
{
    if (!propertiesDict) {
        [NSException raise:NSInvalidArgumentException
                    format:@"Properties dictionary cannot be nil."];
    }
    
    // All the expected keys must be present in the dictionary.
    NSSet *expectedKeysSet = [[NSSet alloc] initWithArray:@[@"name", @"city", @"description", @"speech",
                                                            @"default_floor", @"floors"]];
    NSSet *dictKeysSet = [[NSSet alloc] initWithArray:[propertiesDict allKeys]];
    
    if (![dictKeysSet isEqualToSet:expectedKeysSet]) {
        [NSException raise:NSInvalidArgumentException
                    format:@"Properties dictionary does not contain all the expected keys.\n"
                            "Dictionary Keys: %@\nExpected Keys: %@", dictKeysSet, expectedKeysSet];
    }
}

/**
 * Returns a new array of \c TCMuseumFloor objects from given array property.
 *
 * @param floorsArray The \c \@"floors" property that was extracted from the properties dictionary.
 *
 * @return A new \c NSArray holding \c TCMuseumFloor objects.
 */
FOUNDATION_STATIC_INLINE NSArray *TCMuseumFloorsFromArrayProperty(NSArray *floorsArray)
{
    NSMutableArray *floors = [[NSMutableArray alloc] initWithCapacity:floorsArray.count];
    
    for (NSDictionary *floorProperties in floorsArray) {
        TCMuseumFloor *floor = [[TCMuseumFloor alloc] initWithProperties:floorProperties];
        [floors addObject:floor];
    }
    
    return [floors copy];
}

@end
