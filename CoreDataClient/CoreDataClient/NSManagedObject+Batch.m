//
//  NSManagedObject+Batch.m
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//


#import "NSManagedObject+Batch.h"
#import "NCCCoreDataClient.h"

@interface NSDictionary (CompareManagedObject)

- (NSComparisonResult)compareById:(NSManagedObject *)managedObject;

@end

@implementation NSDictionary (CompareManagedObject)

- (NSComparisonResult)compareById:(NSManagedObject *)managedObject
{
    if (managedObject) {
        id remoteUid = [self valueForKey:[[managedObject class] responseObjectUidKey]];
        if ([remoteUid isKindOfClass:[NSNumber class]]) {
            remoteUid = [remoteUid stringValue];
        }
        id localUid = [managedObject valueForKey:[[managedObject class] managedObjectUidKey]];
        if ([localUid isKindOfClass:[NSNumber class]]) {
            localUid = [localUid stringValue];
        }
        return[remoteUid compare:localUid options:NSNumericSearch]; // NSNumericSearch in case values are strings
    } else {
        return NSOrderedAscending;
    }
}

@end

@implementation NSManagedObject (Batch)

+ (NSArray *)batchUpdateAndWaitObjects:(NSArray *)objects destinationContext:(NSManagedObjectContext *)context error:(NSError **)outError
{
    CGFloat progress = 0;
    return [self batchUpdateAndWaitObjects:objects destinationContext:context progress:&progress error:outError];
}

+ (NSArray *)batchUpdateAndWaitObjects:(NSArray *)objects  destinationContext:(NSManagedObjectContext *)context progress:(CGFloat *)outProgress error:(NSError **)outError
{
    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    childContext.parentContext = context;
    
    __block NSArray *resultObjects;
    
    [childContext performBlockAndWait:^{
        resultObjects = [self managedObjectsWithResponseObjects:objects context:childContext progress:nil];
    }];
    
    NSError *error = nil;
    if (outError != NULL) {
        error = *outError;
    }
    if (![NSManagedObject saveContextAndWait:childContext error:&error]) {
        NSLog(@"Core Data Save Error: %@, %@", self, [error localizedDescription]);
    }
    
    return resultObjects;
}

+ (void)batchUpdateObjects:(NSArray *)objects destinationContext:(NSManagedObjectContext *)context completion:(void(^)(NSArray *results, NSError *error))completion
{
    return [self batchUpdateObjects:objects destinationContext:context progress:nil completion:completion];
}

+ (void)batchUpdateObjects:(NSArray *)objects destinationContext:(NSManagedObjectContext *)context progress:(void(^)(CGFloat progress))progress completion:(void(^)(NSArray *results, NSError *error))completion
{
    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    childContext.parentContext = context;
    
    [childContext performBlock:^{
        
        NSArray *resultObjects = [self managedObjectsWithResponseObjects:objects context:childContext progress:progress];
        
        [NSManagedObject saveContext:childContext completion:^(NSError *error) {
            if (error) {
                NSLog(@"Core Data Save Error: %@, %@", self, error.localizedDescription);
            }
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(resultObjects, error);
                });
            }
        }];
    }];
}

+ (NSSortDescriptor *)sortDescriptorForKey:(NSString *)key
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:YES comparator:^NSComparisonResult(id id1, id id2) {
        if ([id1 respondsToSelector:@selector(compare:options:)]) {
            return [id1 compare:id2 options:NSNumericSearch]; // NSNumericSearch in case values are strings
        }
        return [id1 compare:id2];
    }];
    
    return sortDescriptor;
}

+ (NSPredicate *)predicateOnExistenceOfProperty:(NSString *)key
{
    return [NSPredicate predicateWithFormat:@"%K != nil", key];
}

+ (NSArray *)managedObjectsWithResponseObjects:(NSArray *)objects context:(NSManagedObjectContext *)context progress:(void(^)(CGFloat progress))progress
{
    NSMutableArray *upsertedObjects = [NSMutableArray array];
    
    NSArray *filteredResponseObjects = [objects filteredArrayUsingPredicate:[self predicateOnExistenceOfProperty:[self responseObjectUidKey]]];
    NSArray *sortedResponseObjects = [filteredResponseObjects sortedArrayUsingDescriptors:@[[self sortDescriptorForKey:[self responseObjectUidKey]]]];
    
    NSArray *sortedManagedObjects = @[];
    NSArray *keys = [[[NSEntityDescription entityForName:self.classNameWithoutNamespace inManagedObjectContext:context] attributesByName] allKeys];
    if([keys containsObject:[self managedObjectUidKey]]) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.predicate = [self predicateOnExistenceOfProperty:[self managedObjectUidKey]];
        [fetchRequest setEntity: [NSEntityDescription entityForName:self.classNameWithoutNamespace inManagedObjectContext:context]];
        
        NSError *error;
        sortedManagedObjects = [[context executeFetchRequest:fetchRequest error:&error] sortedArrayUsingDescriptors:@[[self sortDescriptorForKey:[self managedObjectUidKey]]]];
    }
    
    // Walk the arrays
    __block NSEnumerator *sortedManagedObjectsEnumerator = [sortedManagedObjects objectEnumerator];
    __block NSManagedObject *nextManagedObject = [sortedManagedObjectsEnumerator nextObject];
    [sortedResponseObjects enumerateObjectsUsingBlock:^(NSDictionary *responseObject, NSUInteger idx, BOOL *stop) {
        
        NSComparisonResult comparison = [responseObject compareById:nextManagedObject];
        
        // Delete, localUid not in remoteObjects, delete until next local object uid matches current remote uid
        while (comparison == NSOrderedDescending && nextManagedObject) {
            [context deleteObject:nextManagedObject];
            nextManagedObject = [sortedManagedObjectsEnumerator nextObject];
            comparison = [responseObject compareById:nextManagedObject];
        }
        // Add or Update
        if (comparison == NSOrderedSame) { // same uids from both lists, UPDATE
            [nextManagedObject updateWithDictionary:responseObject];
            [upsertedObjects addObject:[context.parentContext objectWithID:nextManagedObject.objectID]];
            nextManagedObject = [sortedManagedObjectsEnumerator nextObject];
        } else if (comparison == NSOrderedAscending) { // remoteUid not in fetchedObjects, NEW
            // new
            NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:self.classNameWithoutNamespace inManagedObjectContext:context];
            [object updateWithDictionary:responseObject];
            [upsertedObjects addObject:[context.parentContext objectWithID:object.objectID]];
        }
        
        if (progress) {
            float percent = (float)idx / (float)sortedResponseObjects.count;
            progress(percent);
        }
    }];
    
    // DELETE local objects that are beyond end of remote objects array
    while (nextManagedObject) {
        [context deleteObject:nextManagedObject];
        nextManagedObject = [sortedManagedObjectsEnumerator nextObject];
    }
    
    // Add objects that have no id property
    NSMutableArray *objectsWithoutIds = [NSMutableArray arrayWithArray:objects];
    [objectsWithoutIds removeObjectsInArray:filteredResponseObjects];
    [objectsWithoutIds enumerateObjectsUsingBlock:^(NSDictionary *responseObject, NSUInteger idx, BOOL *stop) {
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:self.classNameWithoutNamespace inManagedObjectContext:context];
        [object updateWithDictionary:responseObject];
        [upsertedObjects addObject:[context.parentContext objectWithID:object.objectID]];
        
        if (progress) {
            float percent = (float)idx / (float)objects.count;
            progress(percent);
        }
    }];
    
    return upsertedObjects;
}

@end


