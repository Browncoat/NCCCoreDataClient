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

- (void)testThatItBatchingAddsManagedObject
{
    // given
    NSArray *responseObjects = @[@{@"id":@"0"},@{@"id":@"1"},@{@"id":@"2"},@{@"id":@"3"}];
    
    // when
    XCTestExpectation *expectation = [self expectationWithDescription:@"Batch Response Objects"];
    [Person batchUpdateObjects:responseObjects destinationContext:[NSManagedObjectContext mainContext] completion:^(NSArray *results, NSError *error) {
        XCTAssertEqual(responseObjects.count, results.count);
        [expectation fulfill];
    }];
    
    // then
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}

- (void)testThatItBatchingRemovesManagedObject
{
    // given
    NSArray *responseObjects = @[@{@"id":@"1"},@{@"id":@"2"},@{@"id":@"3"}];
    
    // when
    XCTestExpectation *expectation = [self expectationWithDescription:@"Batch Response Objects"];
    [Person batchUpdateObjects:responseObjects destinationContext:[NSManagedObjectContext mainContext] completion:^(NSArray *results, NSError *error) {
        NSArray *allPersons = [Person allObjects];
        XCTAssertEqual(responseObjects.count, allPersons.count);
        [expectation fulfill];
    }];
    
    // then
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}

@end
