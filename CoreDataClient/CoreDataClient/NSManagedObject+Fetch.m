//
//  NSManagedObject+Fetch.m
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import "NSManagedObject+Fetch.h"
#import "NCCCoreDataClient.h"

@implementation NSManagedObject (Fetch)

+ (NSArray *)allObjects
{
    return [self allObjectsInManagedObjectContext:[NSManagedObjectContext mainContext]];
}

+ (NSArray *)allObjectsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.classNameWithoutNamespace inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.includesSubentities = NO;
    request.entity = entity;
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!error) {
        return results;
    }
    
    return nil;
}

+ (NSArray *)objectsWithId:(id)uid
{
    return [self objectsWithId:uid inManagedObjectContext:[NSManagedObjectContext mainContext]];
}

+ (NSArray *)objectsWithId:(id)uid inManagedObjectContext:(NSManagedObjectContext *)context
{
    __block NSArray *results;
    __block NSError *error;
    
    [context performBlockAndWait:^{
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:self.classNameWithoutNamespace inManagedObjectContext:context];
        request.entity = entity;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", [self managedObjectUidKey], uid];
        request.predicate = predicate;
        request.includesSubentities = NO;
        
        results = [context executeFetchRequest:request error:&error];
    }];
    
    if (!error) {
        return results;
    }
    
    return nil;
}

+ (instancetype)objectWithId:(id)uid inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *results = [[self class] objectsWithId:uid inManagedObjectContext:context];
    if (results.count > 1) NSLog(@"More than one %@ object with unique id not expected", self);
    
    return [results lastObject];
}

+ (id)objectWithId:(id)uid
{
    NSArray *results = [[self class] objectsWithId:uid];
    if (results.count > 1) NSLog(@"More than one %@ object with unique id not expected", self);
    
    return [results lastObject];
}

+ (NSArray *)allUids
{
    NSManagedObjectContext *context = [NSManagedObjectContext mainContext];
    NSEntityDescription *entity = [NSEntityDescription  entityForName:self.classNameWithoutNamespace inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    [request setReturnsDistinctResults:YES];
    [request setPropertiesToFetch:@[[self managedObjectUidKey]]];
    
    // Execute the fetch.
    NSError *error;
    NSArray *uids = [[context executeFetchRequest:request error:&error] valueForKey:[self managedObjectUidKey]];
    if (uids == nil) {
        NSLog(@"Error retrieving UIDS for Entity %@", NSStringFromClass([self class]));
    }
    
    return uids;
}

- (instancetype)mainContextObject
{
    return [[NSManagedObjectContext mainContext] objectWithID:self.objectID];
}

/*
+ (NSArray *)allObjectsWithAttribute(id)attribute inArray:(NSArray *)attributes inContext:(NSManagedObjectContext *)context
{
    NSArray *sortedAttributes = [attributes sortedArrayUsingSelector:@selector(compare:)];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity: [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat:@"(%K IN %@)", attribute, sortedAttributes]];
    
    // make sure the results are sorted as well
    [fetchRequest setSortDescriptors: @[[[NSSortDescriptor alloc] initWithKey:attribute ascending:YES]]];
    
    NSError *error;
    NSArray *fetchedObjectsMatchingRemoteIds = [context executeFetchRequest:fetchRequest error:&error];
}
*/

@end
