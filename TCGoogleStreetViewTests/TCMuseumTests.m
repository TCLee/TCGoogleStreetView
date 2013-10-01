//
//  TCMuseumTests.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/30/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TCMuseum.h"

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

- (void)testInitWithProperties
{
    NSDictionary *properties = @{
        @"name": @"",
        @"city": @"",
        @"description": @"",
        @"speech": @"",
    };
    TCMuseum *museum = [[TCMuseum alloc] initWithProperties:properties];
    
    XCTAssertEqualObjects(museum.name, @"", @"Museum name was not initialized properly from dictionary.");
    XCTAssertEqualObjects(museum.city, @"", @"City was not initialized properly from dictionary.");
}

@end
