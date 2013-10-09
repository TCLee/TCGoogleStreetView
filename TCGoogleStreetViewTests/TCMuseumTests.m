//
//  TCMuseumTests.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/30/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TCMuseum.h"
#import "TCMuseumFloor.h"

/**
 * Test class that contains the test methods to exercise the \b TCMuseum
 * model class API.
 */
@interface TCMuseumTests : XCTestCase

@end

@implementation TCMuseumTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

/**
 * Test that \c TCMuseum properties is initialized properly from 
 * a dictionary.
 */
- (void)testInitWithDictionary
{
    NSDictionary *properties = @{
        @"name": @"Museum Name",
        @"city": @"City, Country",
        @"description": @"The museum's description.",
        @"speech": @"The text to be spoken.",
        @"default_floor": @1,
        @"floors": @[
            @{
                @"name": @"First Floor",
                @"coordinate": @{@"latitude": @10, @"longitude": @20},
                @"camera": @{@"FOV": @75, @"zoom": @1, @"heading": @20, @"pitch": @10}
            },
            @{
                @"name": @"Second Floor",
                @"coordinate": @{@"latitude": @10, @"longitude": @20},
                @"camera": @{@"FOV": @75, @"zoom": @1, @"heading": @20, @"pitch": @10}
            },
        ]
    };
    TCMuseum *museum = [[TCMuseum alloc] initWithProperties:properties];
    
    XCTAssertNotNil(museum, @"Should return a non-nil TCMuseum instance, if we passed in valid properties.");
    XCTAssertEqualObjects(museum.name, @"Museum Name", @"Museum's name was not initialized properly from dictionary.");
    XCTAssertEqualObjects(museum.city, @"City, Country", @"City was not initialized properly from dictionary.");
    XCTAssertEqualObjects(museum.text, @"The museum's description.", @"Museum's description was not initialized properly from dictionary.");
    XCTAssertEqualObjects(museum.speechText, @"The text to be spoken.", @"Speech string was not initialized properly from dictionary.");
    
    XCTAssertTrue(museum.defaultFloorIndex == 1, @"Default floor index was not initialized properly from dictionary.");
    XCTAssertTrue(museum.defaultFloor == museum.floors[museum.defaultFloorIndex], @"Default floor property should reference the same object in array.");    
    XCTAssertTrue(museum.floors.count == 2, @"The museum's number of floors does not match dictionary.");
    XCTAssertTrue([museum.floors[0] isKindOfClass:[TCMuseumFloor class]] && [museum.floors[1] isKindOfClass:[TCMuseumFloor class]],
                  @"The floors array should only contain TCMuseumFloor objects.");
}

/**
 * Test that TCMuseum throws an exception if \c initWithProperties:
 * method was passed in \c nil.
 */
- (void)testInitWithNil
{
    XCTAssertThrows([[TCMuseum alloc] initWithProperties:nil],
                    @"TCMuseum should not accept nil properties.");
}

/**
 * Test that TCMuseum throws an exception if properties dictionary is missing
 * expected keys.
 */
- (void)testInitWithMissingProperties
{
    NSDictionary *missingProperties = @{
        @"name": @"Museum Name",
        @"city": @"City, Country",
        @"description": @"The museum's description.",
    };
    
    XCTAssertThrows([[TCMuseum alloc] initWithProperties:missingProperties],
                    @"TCMuseum should assert that the dictionary has all the expected properties.");
}

@end
