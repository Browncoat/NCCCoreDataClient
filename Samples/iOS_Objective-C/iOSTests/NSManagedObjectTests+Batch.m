//
//  NSManagedObjectTests+Batch.m
//  CoreDataClient
//
//  Created by Nate Potter on 3/5/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import "NSManagedObjectTests.m"
#import "Person.h"

@interface NSManagedObjectTests (Batch)

@end

@implementation NSManagedObjectTests (Batch)

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testThatItAddsManagedObjects
{
    // given
    NSArray *responseObjects = @[@{@"id":@"0"},@{@"id":@"1"},@{@"id":@"2"},@{@"id":@"3"},@{@"id":@"4"},@{@"id":@"5"}];
    
    // when
    XCTestExpectation *expectation = [self expectationWithDescription:@"Batch Response Objects"];
    [Person batchUpdateObjects:responseObjects destinationContext:self.managedObjectContext completion:^(NSArray *results, NSError *error) {
        NSArray *allResponseObjectIds = [self arrayOfSortedIdsForArray:responseObjects];
        NSArray *allPersonIds = [self arrayOfSortedIdsForArray:[Person allObjectsInManagedObjectContext:self.managedObjectContext]];
        
        // then
        XCTAssertTrue([allResponseObjectIds isEqualToArray:allPersonIds]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}

- (void)testThatItRemovesFirstManagedObject
{
    // given
    [self addPersonObjectsWithIds:@[@"0", @"1", @"2", @"3", @"4", @"5"] inContext:self.managedObjectContext];
    NSArray *responseObjects = @[@{@"id":@"1"},@{@"id":@"2"},@{@"id":@"3"},@{@"id":@"4"},@{@"id":@"5"}];
    
    // when
    XCTestExpectation *expectation = [self expectationWithDescription:@"Batch Response Objects"];
    [Person batchUpdateObjects:responseObjects destinationContext:self.managedObjectContext completion:^(NSArray *results, NSError *error) {
        NSArray *allResponseObjectIds = [self arrayOfSortedIdsForArray:responseObjects];
        NSArray *allPersonIds = [self arrayOfSortedIdsForArray:[Person allObjectsInManagedObjectContext:self.managedObjectContext]];
        
        // then
        XCTAssertTrue([allResponseObjectIds isEqualToArray:allPersonIds]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}

- (void)testThatItRemovesMiddleManagedObject
{
    // given
    [self addPersonObjectsWithIds:@[@"0", @"1", @"2", @"3", @"4", @"5"] inContext:self.managedObjectContext];
    
    NSArray *responseObjects = @[@{@"id":@"0"},@{@"id":@"1"},@{@"id":@"2"},@{@"id":@"3"},@{@"id":@"5"}];
    
    // when
    XCTestExpectation *expectation = [self expectationWithDescription:@"Batch Response Objects"];
    [Person batchUpdateObjects:responseObjects destinationContext:self.managedObjectContext completion:^(NSArray *results, NSError *error) {
        NSArray *allResponseObjectIds = [self arrayOfSortedIdsForArray:responseObjects];
        NSArray *allPersonIds = [self arrayOfSortedIdsForArray:[Person allObjectsInManagedObjectContext:self.managedObjectContext]];
        
        // then
        XCTAssertTrue([allResponseObjectIds isEqualToArray:allPersonIds]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}

- (void)testThatItRemovesLastManagedObject
{
    // given
    [self addPersonObjectsWithIds:@[@"0", @"1", @"2", @"3", @"4", @"5"] inContext:self.managedObjectContext];
    NSArray *responseObjects = @[@{@"id":@"0"},@{@"id":@"1"},@{@"id":@"2"},@{@"id":@"3"},@{@"id":@"4"}];
    
    // when
    XCTestExpectation *expectation = [self expectationWithDescription:@"Batch Response Objects"];
    [Person batchUpdateObjects:responseObjects destinationContext:self.managedObjectContext completion:^(NSArray *results, NSError *error) {
        NSArray *allResponseObjectIds = [self arrayOfSortedIdsForArray:responseObjects];
        NSArray *allPersonIds = [self arrayOfSortedIdsForArray:[Person allObjectsInManagedObjectContext:self.managedObjectContext]];
        
        // then
        XCTAssertTrue([allResponseObjectIds isEqualToArray:allPersonIds]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}

- (void)testThatItAddsManagedObjectsWithoutId
{
    // given
    [self addPersonObjectsWithIds:@[@"0", @"1", @"2", @"3", @"4", @"5"] inContext:self.managedObjectContext];
    NSArray *responseObjects = @[@{@"id":@""},@{@"id":@""},@{@"id":@"0"},@{@"id":@"1"},@{@"id":@"2"},@{@"id":@"3"},@{@"id":@"4"},@{@"id":@"5"}];
    
    // when
    XCTestExpectation *expectation = [self expectationWithDescription:@"Batch Response Objects"];
    [Person batchUpdateObjects:responseObjects destinationContext:self.managedObjectContext completion:^(NSArray *results, NSError *error) {
        NSArray *allPersons = [Person allObjectsInManagedObjectContext:self.managedObjectContext];
        
        // then
        XCTAssertEqual(responseObjects.count, allPersons.count);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}

- (void)testThatItUpdatesManagedObject
{
    // given
    NSString *displayName = @"Jane Doe";
    [self addPersonObjectsWithIds:@[@"0", @"1", @"2", @"3", @"4", @"5"] inContext:self.managedObjectContext];
    NSArray *responseObjects = @[@{@"id":@"0"},@{@"id":@"1", @"displayName":displayName},@{@"id":@"2"},@{@"id":@"3"},@{@"id":@"3"},@{@"id":@"4"},@{@"id":@"5"}];
    
    // when
    XCTestExpectation *expectation = [self expectationWithDescription:@"Batch Response Objects"];
    [Person batchUpdateObjects:responseObjects destinationContext:self.managedObjectContext completion:^(NSArray *results, NSError *error) {
        Person *janeDoe = [Person objectWithId:@"1" inManagedObjectContext:self.managedObjectContext];
        
        // then
        XCTAssertEqual(janeDoe.displayName, displayName);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}

- (NSArray *)arrayOfSortedIdsForArray:(NSArray *)array
{
    NSArray *sortedIds = [[array valueForKey:@"id"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    return sortedIds;
}

- (void)addPersonObjectsWithIds:(NSArray *)uids inContext:(NSManagedObjectContext *)context
{
    for (NSString *uid in uids) {
        Person *person = (Person *)[[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        person.id = uid;
    }
}

@end
