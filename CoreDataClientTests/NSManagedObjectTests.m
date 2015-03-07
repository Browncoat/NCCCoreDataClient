//
//  NSManagedObjectTests.m
//  CoreDataClient
//
//  Created by Nate Potter on 3/5/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectTests : XCTestCase

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSPersistentStore *persistentStore;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation NSManagedObjectTests

- (void)setUp {
    [super setUp];
    
    [self setUpDataStack];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

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

- (void)setUpDataStack
{
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    _persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType: NSInMemoryStoreType
                                      configuration: nil
                                                URL: nil
                                            options: nil
                                              error: NULL];
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

@end
