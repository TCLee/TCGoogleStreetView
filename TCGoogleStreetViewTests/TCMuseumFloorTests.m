//
//  TCMuseumFloorTests.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/8/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TCMuseumFloor.h"
#import "GMSPanoramaCamera+Debug.h"

/**
 * Test class for \c TCMuseumFloor public methods.
 */
@interface TCMuseumFloorTests : XCTestCase

@end

@implementation TCMuseumFloorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/**
 * Test that \c TCMuseumFloor properties can be initialized properly
 * from a dictionary.
 */
- (void)testInitWithDictionary
{
    NSDictionary *properties = @{
        @"name": @"G",
        @"coordinate": @{@"latitude": @40, @"longitude": @20},
        @"camera": @{@"FOV": @90, @"zoom": @1, @"heading": @200, @"pitch": @10}
    };
    
    TCMuseumFloor *floor = [[TCMuseumFloor alloc] initWithProperties:properties];
    
    XCTAssertEqualObjects(floor.name, @"G", @"Museum floor's name does not match properties dictionary.");
    
    CLLocationCoordinate2D expectedCoordinate = CLLocationCoordinate2DMake(40, 20);
    XCTAssertEqual(floor.coordinate, expectedCoordinate, @"Museum floor's street view coordinates does not match properties dictionary.");
    
    GMSPanoramaCamera *expectedCamera = [GMSPanoramaCamera cameraWithHeading:200 pitch:10 zoom:1 FOV:90];
    XCTAssertTrue([floor.camera isEqualToPanoramaCamera:expectedCamera], @"Museum floor's camera does not match properties dictionary.");
}

/**
 * Test that \c TCMuseumFloor will thrown an exception if properties dictionary
 * is \c nil.
 */
- (void)testInitWithNil
{
    XCTAssertThrows([[TCMuseumFloor alloc] initWithProperties:nil],
                    @"TCMuseumFloor should not accept nil properties.");
}

@end
