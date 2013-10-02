//
//  TCStaticMapTests.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/1/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TCStaticMap.h"

@interface TCStaticMapTests : XCTestCase

@end

@implementation TCStaticMapTests

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
 * Test that the \c scale property will automatically set itself to a valid value when
 * initialized or it was given an invalid value.
 */
- (void)testScale
{
    TCStaticMap *staticMap = [[TCStaticMap alloc] initWithMarkerLocation:kCLLocationCoordinate2DInvalid
                                                                    zoom:0
                                                                    size:CGSizeZero
                                                                   scale:0];
    XCTAssertTrue(staticMap.scale == 1, @"Scale should be set to 1, if value lower than 1 is given.");
    
    staticMap = [[TCStaticMap alloc] initWithMarkerLocation:kCLLocationCoordinate2DInvalid
                                                       zoom:0
                                                       size:CGSizeZero
                                                      scale:10];
    XCTAssertTrue(staticMap.scale == 2, @"Scale should be set to 2, if value higher than 2 is given.");
}

/**
 * Test that \c TCStaticMap's initializer returns the correct 
 * Google Static Maps API request URL to retrieve the map image.
 */
- (void)testImageURL
{
    TCStaticMap *staticMap = [[TCStaticMap alloc] initWithMarkerLocation:CLLocationCoordinate2DMake(10.5f, 20.5f)
                                                                    zoom:12
                                                                    size:CGSizeMake(200.0f, 300.0f)
                                                                   scale:2];
    
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?center%%3D10.5%%2C20.5%%26zoom%%3D12%%26size%%3D200x300%%26scale%%3D2%%26markers%%3D10.5%%2C20.5%%26visual_refresh%%3Dtrue%%26sensor%%3Dfalse",
                                              TCGoogleStaticMapsAPIBaseURLString]];
    
    XCTAssertEqualObjects(staticMap.imageURL, requestURL, @"The static map image URL does not match the expected request URL.");
}

@end
