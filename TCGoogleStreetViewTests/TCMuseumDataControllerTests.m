//
//  TCMuseumDataControllerTests.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 10/1/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TCMuseumDataController.h"
#import "TCMuseum.h"

/**
 * Test class for \c TCMuseumDataController public methods.
 */
@interface TCMuseumDataControllerTests : XCTestCase

@property (nonatomic, strong) TCMuseumDataController *dataController;
@property (nonatomic, strong) NSArray *allMuseums;

@end

@implementation TCMuseumDataControllerTests

- (void)setUp
{
    [super setUp];

    // Load the test data from our test bundle.
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSURL *testDataURL = [testBundle URLForResource:@"MuseumTestData" withExtension:@"json"];
    
    self.dataController = [[TCMuseumDataController alloc] initWithURL:testDataURL];
    self.allMuseums = [self.dataController allMuseums];
}

- (void)tearDown
{
    [super tearDown];
    
    self.allMuseums = nil;
    self.dataController = nil;
}

/**
 * Test that we can successfully retrieve the first museum from the 
 * collection of museums.
 */
- (void)testFirstMuseum
{
    TCMuseum *firstMuseum = [self.dataController firstMuseum];
    
    XCTAssertEqualObjects(firstMuseum, [self.allMuseums firstObject], @"Data controller should return the first museum object.");
    XCTAssertEqualObjects(firstMuseum, [self.dataController currentMuseum], @"Current museum should be the first museum object.");
}

/**
 * Test that we can successfully retrieve the last museum from the
 * collection of museums.
 */
- (void)testLastMuseum
{
    TCMuseum *lastMuseum = [self.dataController lastMuseum];
    
    XCTAssertEqualObjects(lastMuseum, [self.allMuseums lastObject], @"Data controller should return the last museum object.");
    XCTAssertEqualObjects(lastMuseum, [self.dataController currentMuseum], @"Current museum should be the first museum object.");
}

/**
 * Test that we can retrieve the next (second) museum from the list when 
 * data controller's enumerator is at the first museum.
 */
- (void)testNextMuseumAfterFirstMuseum
{
    [self.dataController firstMuseum];
    TCMuseum *secondMuseum = [self.dataController nextMuseum];
    
    XCTAssertEqualObjects(secondMuseum, self.allMuseums[1], @"Data controller should return the second museum object.");
    XCTAssertEqualObjects(secondMuseum, [self.dataController currentMuseum], @"Current museum should be the second museum object.");
}

/**
 * Test that the data controller should loop back to the first museum 
 * after the last museum.
 */
- (void)testNextMuseumAfterLastMuseum
{
    [self.dataController lastMuseum];
    TCMuseum *firstMuseum = [self.dataController nextMuseum];
    
    XCTAssertEqualObjects(firstMuseum, [self.allMuseums firstObject], @"Data controller should return the first museum object.");
    XCTAssertEqualObjects(firstMuseum, [self.dataController currentMuseum], @"Current museum should be the first museum object.");
}

/**
 * Test that the previous museum before the second museum should return the 
 * first museum object.
 */
- (void)testPreviousMuseumBeforeSecondMuseum
{
    [self.dataController firstMuseum];
    [self.dataController nextMuseum];
    TCMuseum *firstMuseum = [self.dataController previousMuseum];
    
    XCTAssertEqualObjects(firstMuseum, [self.allMuseums firstObject], @"Data controller should return the first museum object.");
    XCTAssertEqualObjects(firstMuseum, [self.dataController currentMuseum], @"Current museum should be the first museum object.");
}

/**
 * Test that the previous museum before the first museum should 
 * loop back to the last museum.
 */
- (void)testPreviousMuseumBeforeFirstMuseum
{
    [self.dataController firstMuseum];
    TCMuseum *lastMuseum = [self.dataController previousMuseum];
    
    XCTAssertEqualObjects(lastMuseum, [self.allMuseums lastObject], @"Data controller should return the last museum object.");
    XCTAssertEqualObjects(lastMuseum, [self.dataController currentMuseum], @"Current museum should be the last museum object.");
}

/**
 * Test removing all museums from the list. The museums should be
 * recreated and cached again, when we access it the next time.
 */
- (void)testRemoveAllMuseums
{
    NSArray *oldMuseumsArray = [self.dataController allMuseums];
    [self.dataController removeAllMuseums];
    NSArray *newMuseumsArray = [self.dataController allMuseums];

    XCTAssertTrue(newMuseumsArray != oldMuseumsArray, @"Museums array should have been re-created after it was released.");
    XCTAssertNotNil(newMuseumsArray, @"The museum objects should be re-created after they were removed.");
    XCTAssertNoThrow([self.dataController currentMuseum], @"Should be able to access the current museum object.");
    XCTAssertNoThrow([self.dataController firstMuseum], @"Should be able to access the first museum object.");
    XCTAssertNoThrow([self.dataController lastMuseum], @"Should be able to access the last museum object.");
    XCTAssertNoThrow([self.dataController nextMuseum], @"Should be able to access the next museum object.");
    XCTAssertNoThrow([self.dataController previousMuseum], @"Should be able to access the previous museum object.");
}

@end
