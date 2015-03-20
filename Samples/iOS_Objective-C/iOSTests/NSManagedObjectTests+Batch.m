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

- (void)testThatItAddsManagedObject
{
    // given
    NSArray *responseObjects = @[@{@"id":@"0"},@{@"id":@"1"},@{@"id":@"2"},@{@"id":@"3"},@{@"id":@"4"},@{@"id":@"5"}];
    
    // when
    XCTestExpectation *expectation = [self expectationWithDescription:@"Batch Response Objects"];
    [Person batchUpdateObjects:responseObjects destinationContext:self.managedObjectContext completion:^(NSArray *results, NSError *error) {
        
        // then
        XCTAssertEqual(responseObjects.count, results.count);
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
    NSArray *responseObjects = @[@{@"id":@"1"},@{@"id":@"2"},@{@"id":@"3"},@{@"id":@"4"},@{@"id":@"5"}];
    
    // when
    XCTestExpectation *expectation = [self expectationWithDescription:@"Batch Response Objects"];
    [Person batchUpdateObjects:responseObjects destinationContext:self.managedObjectContext completion:^(NSArray *results, NSError *error) {
        NSArray *allResponseObjectIds = [[responseObjects valueForKey:@"id"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        NSArray *allPersonIds = [[[Person allObjectsInManagedObjectContext:self.managedObjectContext] valueForKey:@"id"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        
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
    NSArray *responseObjects = @[@{@"id":@"1"},@{@"id":@"2"},@{@"id":@"3"}];
    
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

- (void)testThatItRemovesLastManagedObject
{
    // given
    NSArray *responseObjects = @[@{@"id":@"1"},@{@"id":@"2"},@{@"id":@"3"}];
    
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

- (void)testThatItAddsManagedObjectWithoutId
{
    // given
    NSArray *responseObjects = @[@{@"id":@""},@{@"id":@"1"},@{@"id":@"2"},@{@"id":@"3"}];
    
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

- (void)testThatItUpdatesManagedObjectWithout
{
    // given
    NSString *displayName = @"Jane Doe";
    NSArray *responseObjects = @[@{@"id":@"1", @"displayName":displayName},@{@"id":@"2"},@{@"id":@"3"}];
    
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

@end
