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

/**
 * The URL of the JSON data source.
 */
@property (nonatomic, copy) NSURL *dataURL;

/** 
 * The index of the current museum. The current index will be updated each time a
 * museum is accessed using the "Get Museum in Array" methods.
 */
@property (nonatomic, assign) NSUInteger currentIndex;

/**
 * The index of the last museum in the array. The last index is calculated 
 * and cached when this property is first accessed.
 */
@property (nonatomic, assign, readonly) NSUInteger lastIndex;

/**
 * The array of \c TCMuseum objects. The array is initialized and cached 
 * when this property is first accessed.
 *
 * @note On receiving a memory warning notification, all the museum objects in
 *       the array will be removed. The next time this property is accessed it 
 *       will reload and cache the museum objects again.
 */
@property (nonatomic, strong, readonly) NSArray *museumList;

@end

@implementation TCMuseumDataController

@synthesize museumList = _museumList;
@synthesize lastIndex = _lastIndex;

- (id)initWithURL:(NSURL *)url
{
    NSParameterAssert(url);
    
    self = [super init];

    if (self) {
        _dataURL = [url copy];

        // Start at the first museum object.
        _currentIndex = 0;

        // Set to an invalid value. Last index will be calculated and
        // cached when its property is accessed.
        _lastIndex = NSNotFound;

        // Purge all museum objects when we receive a memory warning
        // from the OS.
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(removeAllMuseums)
         name:UIApplicationDidReceiveMemoryWarningNotification
         object:nil];
    }

    return self;
}

#pragma mark - Get Museum in Array

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

#pragma mark - Last Museum Index

- (NSUInteger)lastIndex
{
    if (NSNotFound == _lastIndex) {
        _lastIndex = self.museumList.count - 1;
    }
    return _lastIndex;
}

#pragma mark - Museums Array

- (NSArray *)allMuseums
{
    return [self.museumList copy];
}

// Lazily load the museum objects from resource file.
- (NSArray *)museumList
{
    if (!_museumList) {
        _museumList = [self museumObjectsWithURL:self.dataURL];
    }
    return _museumList;
}

/**
 * Returns an array of \c TCMuseum objects with properties initialized with 
 * JSON data from the given URL.
 *
 * @param url The URL of the JSON data source.
 *
 * @return A \c NSMutableArray of \c TCMuseum objects.
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

#pragma mark - Memory Warning

- (void)removeAllMuseums
{
    // Release the array of museum objects.
    // It will be re-created and cached again when its property
    // is accessed the next time.
    _museumList = nil;

    // Reset the last index, since we've removed all the museums.
    _lastIndex = NSNotFound;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
