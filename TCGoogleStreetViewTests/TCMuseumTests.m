//
//  TCMuseumTests.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/30/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TCMuseum.h"
#import "GMSPanoramaCamera+NSObject.h"

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
 * Test that TCMuseum is initialized properly from the properties dictionary.
 */
- (void)testInitWithProperties
{
    NSDictionary *properties = @{
        @"name": @"Museum Name",
        @"city": @"City, Country",
        @"description": @"The museum's description.",
        @"speech": @"The text to be spoken.",
        @"coordinate": @{@"latitude": @10, @"longitude": @20},
        @"camera": @{@"FOV": @75, @"zoom": @1, @"heading": @20, @"pitch": @10}
    };
    TCMuseum *museum = [[TCMuseum alloc] initWithProperties:properties];
    
    XCTAssertNotNil(museum, @"Should return a non-nil TCMuseum instance, if we passed in valid properties.");
    XCTAssertEqualObjects(museum.name, @"Museum Name", @"Museum's name was not initialized properly from dictionary.");
    XCTAssertEqualObjects(museum.city, @"City, Country", @"City was not initialized properly from dictionary.");
    XCTAssertEqualObjects(museum.description, @"The museum's description.", @"Museum's description was not initialized properly from dictionary.");
    XCTAssertEqualObjects(museum.speechText, @"The text to be spoken.", @"Speech string was not initialized properly from dictionary.");
    XCTAssertEqual(museum.coordinate, CLLocationCoordinate2DMake(10, 20), @"Coordinate was not initialized properly from dictionary.");

    GMSPanoramaCamera *panoramaCamera = [GMSPanoramaCamera cameraWithHeading:20.0f pitch:10.0f zoom:1.0f FOV:75.0f];
    XCTAssertEqualObjects(museum.camera, panoramaCamera, @"Street View camera was not initialized properly from dictionary.");
}

/**
 * Test that TCMuseum throws an exception if it was passed in nil as the properties dictionary.
 */
- (void)testInitWithNil
{
    XCTAssertThrows([[TCMuseum alloc] initWithProperties:nil],
                    @"Should throw an exception if we pass in nil.");
}

@end
