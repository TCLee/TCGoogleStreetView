//
//  TCMuseumDataController.m
//  TCGoogleStreetView
//
//  Created by Lee Tze Cheun on 9/29/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCMuseumDataController.h"
#import "TCMuseum.h"

@interface TCMuseumDataController ()

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) NSUInteger lastIndex;

@property (nonatomic, strong) NSArray *museumList;

@end

@implementation TCMuseumDataController

- (id)initWithURL:(NSURL *)url
{
    NSParameterAssert(url);
    
    self = [super init];
    if (self) {
        // Load data from given URL.
        _museumList = [self museumObjectsWithURL:url];
        
        // Start at the first museum object.
        _currentIndex = 0;
        
        // Calculate and store last index here, so that we don't have
        // to re-calculate it again everytime.
        _lastIndex = [_museumList count] - 1;
    }
    return self;
}

/**
 * Returns an array of \c TCMuseum objects with properties initialized with data
 * from the given URL.
 *
 * @param url The URL of the data.
 *
 * @return A \c NSArray of \c TCMuseum objects.
 */
- (NSArray *)museumObjectsWithURL:(NSURL *)url
{
    NSError *__autoreleasing error = nil;
    NSData *data = [[NSData alloc] initWithContentsOfURL:url
                                                 options:kNilOptions
                                                   error:&error];
    NSAssert(data, [error localizedDescription]);
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                           options:kNilOptions
                                                             error:&error];
    NSAssert(result, [error localizedDescription]);
    
    NSArray *museumsArray = result[@"museums"];
    NSMutableArray *theMuseumList = [[NSMutableArray alloc] initWithCapacity:[museumsArray count]];
    
    for (NSDictionary *museumProperties in museumsArray) {
        TCMuseum *museum = [[TCMuseum alloc] initWithProperties:museumProperties];
        [theMuseumList addObject:museum];
    }
    
    return [theMuseumList copy];
}

- (NSArray *)allMuseums
{
    return [self.museumList copy];
}

- (TCMuseum *)firstMuseum
{
    self.currentIndex = 0;
    return self.museumList[self.currentIndex];
}

- (TCMuseum *)lastMuseum
{
    self.currentIndex = self.lastIndex;
    return self.museumList[self.currentIndex];
}

- (TCMuseum *)nextMuseum
{
    // If at the last museum, loop back to the first museum.
    // Else, just return the next museum.
    return self.currentIndex == self.lastIndex ?
           [self firstMuseum] : self.museumList[++self.currentIndex];
}

- (TCMuseum *)currentMuseum
{
    return self.museumList[self.currentIndex];
}

- (TCMuseum *)previousMuseum
{
    // If at the first museum, loop back to last museum.
    // Else, just return the previous museum.
    return 0 == self.currentIndex ?
           [self lastMuseum] : self.museumList[--self.currentIndex];
}

@end
