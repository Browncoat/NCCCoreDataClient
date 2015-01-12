//
//  NSManagedObject+Delete.m
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import "NSManagedObject+Delete.h"
#import "NCCCoreDataClient.h"

@implementation NSManagedObject (Delete)

+ (void)deleteObjects:(NSSet *)deleteSet inManagedObjectContext:(NSManagedObjectContext *)context
{
    if (deleteSet.count > 0) {
        [context performBlockAndWait:^{
            for (NSManagedObject *object in deleteSet) {
                [context deleteObject:[context objectWithID:object.objectID]];
            }
        }];
    }
}

+ (void)deleteObjects:(NSSet *)deleteSet
{
    [self deleteObjects:deleteSet inManagedObjectContext:[NSManagedObjectContext mainContext]];
}

+ (void)deleteObject:(NSManagedObject *)object inManagedObjectContext:(NSManagedObjectContext *)context
{
    [context deleteObject:object];
}

+ (void)deleteObject:(NSManagedObject *)object
{
    [self deleteObject:object inManagedObjectContext:[NSManagedObjectContext mainContext]];
}

+ (void)deleteAllObjects
{
    [self deleteAllObjectsInManagedObjectContext:[NSManagedObjectContext mainContext]];
}

+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:self.classNameWithoutNamespace inManagedObjectContext:context]];
    [request setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *results = [[NSManagedObjectContext mainContext] executeFetchRequest:request error:&error];
    if (!error) {
        [self deleteObjects:[NSSet setWithArray:results] inManagedObjectContext:context];
    }
}

+ (void)deleteObjectWithId:(NSString *)uid inManagedObjectContext:(NSManagedObjectContext *)context
{
    id deleteObject = [self objectWithId:uid inManagedObjectContext:context];
    [self deleteObject:deleteObject inManagedObjectContext:context];
}

+ (void)deleteObjectWithId:(NSString *)uid
{
    id deleteObject = [self objectWithId:uid inManagedObjectContext:[NSManagedObjectContext mainContext]];
    [self deleteObject:deleteObject inManagedObjectContext:[NSManagedObjectContext mainContext]];
}

@end
