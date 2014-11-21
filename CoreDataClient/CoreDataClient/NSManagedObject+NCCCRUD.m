// NSManagedObject+NCCCRUD.m
//
// Copyright (c) 2013-2014 NCCCoreDataClient (http://coredataclient.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSManagedObject+NCCCRUD.h"
#import "NSDictionary+NCCNullToNil.h"
#import "AppDelegate+NCCCoreData.h"

@implementation NSManagedObject (NCCCRUD)

@dynamic uid;

// XML
+ (instancetype)upsertObjectWithRXMLElement:(RXMLElement *)element uid:(NSString *)uid inManagedObjectContext:(NSManagedObjectContext *)context
{
    id object = nil;
    
    if (uid) {
        // look for object in child context
        object = [[self class] managedObjectWithId:uid inManagedObjectContext:context];
        
        // look for object in main context
        if (!object) {
            object = [[self class] managedObjectWithId:uid];
        }
    }
    
    if (object) {
        // reference object by ID to prevent context errors
        object = [context objectWithID:[object objectID]];
        
        [context performBlockAndWait:^{
            // update object on child context
            [object updateWithRXMLElement:element];
        }];
    } else {
        object = [[self class] insertObjectWithRXMLElement:element inManagedObjectContext:context];
    }
    
    return object;
}

+ (instancetype)insertObjectWithRXMLElement:(RXMLElement *)element inManagedObjectContext:(NSManagedObjectContext *)context
{
    id object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    [object updateWithRXMLElement:element];
    
    return object;
}

- (void)updateWithRXMLElement:(RXMLElement *)element
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

// JSON
+ (instancetype)upsertObjectWithDictionary:(NSDictionary *)dictionary uid:(id)uid inManagedObjectContext:(NSManagedObjectContext *)context
{
    id object = nil;
    
    if (uid) {
        object = [[self class] managedObjectWithId:uid inManagedObjectContext:context];
    }
    
    if (object) {
        // reference object by ID to prevent context errors
        object = [[self mainContext] objectWithID:[object objectID]];
        
        [context performBlockAndWait:^{
            // update object on child context
            [object updateWithAndRemoveNullsFromDictionary:dictionary];
        }];
    } else {
        object = [[self class] insertObjectWithDictionary:dictionary inManagedObjectContext:context];
    }
    
    return object;
}

+ (instancetype)insertObjectWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    __block id object;
    
    [context performBlockAndWait:^{
        
        object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
        
        [object updateWithAndRemoveNullsFromDictionary:dictionary];
    }];
    
    return object;
}

- (void)updateWithAndRemoveNullsFromDictionary:(NSDictionary *)dictionary
{
    // Change NSNUll objects to nil
    dictionary = [dictionary dictionaryByReplacingNullObjectswithNil];
    
    //    NSLog(@"Create / update Instance %@", NSStringFromClass([self class]));
    [self updateWithDictionary:dictionary];
}

/*
- (void)clearAllProperties
{
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        //        NSString *attributesString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
        
        //        NSLog(@"Property %@ attributes: %@", name, attributesString);
        
        id valueForProperty = [self valueForKey:name];
        if ([valueForProperty isKindOfClass:[NSSet class]]) {
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@%@:", @"remove", [name capitalizedString]]);
            IMP imp = [self methodForSelector:selector];
            void (*func)(id, SEL, NSSet *) = (void *)imp;
            func(self, selector, valueForProperty);
            //            [self performSelector:selector withObject:valueForProperty];
        } else if ([valueForProperty isKindOfClass:[NSObject class]]) {
            valueForProperty = nil;
        } else {
            valueForProperty = 0;
        }
    }
    
    free(propertyArray);
}
*/
- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in the %@ class", NSStringFromSelector(_cmd), NSStringFromClass([self class])]
                                 userInfo:nil];
}

+ (instancetype)objectInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:[self mainContext]] insertIntoManagedObjectContext:context];
}


+ (NSArray *)allObjects
{
    return [self allObjectsInManagedObjectContext:self.mainContext];
}

+ (NSArray *)allObjectsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
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

+ (instancetype)managedObjectWithName:(NSString *)name
{
    return [[self class] managedObjectWithName:name inManagedObjectContext:[self mainContext]];
}

+ (instancetype)managedObjectsWith:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    request.includesSubentities = NO;
    request.entity = entity;
    request.predicate = predicate;
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (!error) {
        return [results lastObject];
    }
    
    return nil;
}

+ (NSArray *)managedObjectsWithId:(id)uid
{
    return [self managedObjectsWithId:uid inManagedObjectContext:[self mainContext]];
}

+ (NSArray *)managedObjectsWithId:(id)uid inManagedObjectContext:(NSManagedObjectContext *)context
{
    __block NSArray *results;
    __block NSError *error;
    
    [context performBlockAndWait:^{
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
        request.entity = entity;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@", uid];
        request.predicate = predicate;
        request.includesSubentities = NO;
        
        results = [context executeFetchRequest:request error:&error];
    }];
    
    if (!error) {
        return results;
    }
    
    return nil;
}

+ (instancetype)managedObjectWithId:(id)uid inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *results = [[self class] managedObjectsWithId:uid inManagedObjectContext:context];
    if (results.count > 1) NSLog(@"More than one %@ object with unique id not expected", self);
    
    return [results lastObject];
}

+ (id)managedObjectWithId:(id)uid
{
    NSArray *results = [[self class] managedObjectsWithId:uid];
    if (results.count > 1) NSLog(@"More than one %@ object with unique id not expected", self);
    
    return [results lastObject];
}

+ (NSArray *)allUids
{
    NSManagedObjectContext *context = [NSManagedObject mainContext];
    NSEntityDescription *entity = [NSEntityDescription  entityForName:NSStringFromClass([self class]) inManagedObjectContext:[self mainContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setResultType:NSDictionaryResultType];
    [request setReturnsDistinctResults:YES];
    [request setPropertiesToFetch:@[@"uid"]];
    
    // Execute the fetch.
    NSError *error;
    NSArray *uids = [[context executeFetchRequest:request error:&error] valueForKey:@"uid"];
    if (uids == nil) {
        NSLog(@"Error retrieving UIDS for Entity %@", NSStringFromClass([self class]));
    }
    
    return uids;
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
// Saving
+ (BOOL)saveContextAndWait:(NSManagedObjectContext *)context error:(NSError **)saveError
{
    __block BOOL success = NO;
    
    // check if we're at privateSaveToDiskContext
    if ([context isEqual:self.saveToDiskContext]) {
        NSError *error;
        success = [self.saveToDiskContext save:&error];
    }
    
    if ([context hasChanges]) {
        [context performBlockAndWait:^{
            success = [context save:saveError];
            if (success) {
                // recursively save up the context chain
                if (context.parentContext) {
                    success = [self saveContextAndWait:context.parentContext error:saveError];
                } else {
                    NSLog(@"save done %@", [self class]);
                }
            }
        }];
    } else {
        success = YES;
    }
    
    return success;
}

+ (void)saveContext:(NSManagedObjectContext *)context completion:(void(^)(NSError *error))completion
{
    // check if we're at privateSaveToDiskContext
    if ([context isEqual:self.saveToDiskContext]) {
        
        void (^saveToDisk) (void) = ^ {
            NSError *error;
            BOOL success = [self.saveToDiskContext save:&error];
            if (success) {
                NSLog(@"save done %@", [self class]);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
        };
        
        [self.saveToDiskContext performBlock:saveToDisk];
        
    } else {
        
        if ([context hasChanges]) {
            [context performBlock:^{
                NSError *saveError = nil;
                BOOL success = [context save:&saveError];
                if (success) {
                    // recursively save up the context chain
                    if (context.parentContext) {
                        [self saveContext:context.parentContext completion:completion];
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(saveError);
                    });
                }
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
        }
    }
}

// Helpers

+ (NSManagedObjectContext *)mainContext
{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (instancetype)mainContextObject
{
    return [[NSManagedObject mainContext] objectWithID:self.objectID];
}

+ (NSManagedObjectContext *)saveToDiskContext
{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] privateSaveToDiskContext];
}

+ (void)deleteObjects:(NSSet *)deleteSet inManagedObjectContext:(NSManagedObjectContext *)context
{
    if (deleteSet.count > 0) {
        [context performBlockAndWait:^{
            for (NSManagedObject *object in deleteSet) {
                [context deleteObject:object];
            }
        }];
    }
}

+ (void)deleteObjects:(NSSet *)deleteSet
{
    [self deleteObjects:deleteSet inManagedObjectContext:[self mainContext]];
}

+ (void)deleteObject:(NSManagedObject *)object inManagedObjectContext:(NSManagedObjectContext *)context
{
    [context deleteObject:object];
}

+ (void)deleteObject:(NSManagedObject *)object
{
    [self deleteObject:object inManagedObjectContext:[self mainContext]];
}

+ (void)deleteAllObjects
{
    [self deleteAllObjectsInManagedObjectContext:[self mainContext]];
}

+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context]];
    [request setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *results = [[self mainContext] executeFetchRequest:request error:&error];
    if (!error) {
        [self deleteObjects:[NSSet setWithArray:results] inManagedObjectContext:context];
    }
}

+ (void)deleteObjectWithId:(NSString *)uid inManagedObjectContext:(NSManagedObjectContext *)context
{
    id deleteObject = [self managedObjectWithId:uid inManagedObjectContext:context];
    [self deleteObject:deleteObject inManagedObjectContext:context];
}

+ (void)deleteObjectWithId:(NSString *)uid
{
    id deleteObject = [self managedObjectWithId:uid inManagedObjectContext:[self mainContext]];
    [self deleteObject:deleteObject inManagedObjectContext:[self mainContext]];
}

+ (NSSet *)duplicateManagedObjectsInMainContextForObject:(NSManagedObject *)object
{
    NSSet *duplicateObjects = [NSSet setWithArray:[[object class] managedObjectsWithId:object.uid]];
    
    return duplicateObjects;
}

- (NSString *)loadStringFromDictionary:(NSDictionary*)dict forKey:(NSString *)key
{
    NSString *val = nil;
    if([dict objectForKey:key] && [dict objectForKey:key] != [NSNull null]){ val = [dict objectForKey:key]; }
    return val;
}

- (BOOL)loadBoolFromDictionary:(NSDictionary*)dict forKey:(NSString *)key
{
    BOOL val = NO;
    if([dict objectForKey:key]){ val = [[dict objectForKey:key] boolValue]; }
    return val;
}

+ (NSArray *)batchUpdateAndWaitObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName error:(NSError **)outError
{
    CGFloat progress = 0;
    return [self batchUpdateAndWaitObjects:objects uniqueIdentifierName:uniqueIdentifierName progress:&progress error:outError];
}

+ (NSArray *)batchUpdateAndWaitObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName progress:(CGFloat *)outProgress error:(NSError **)outError
{
    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    childContext.parentContext = [NSManagedObject mainContext];
    
    NSMutableArray *newObjects = [NSMutableArray array];
    NSArray *allObjects = [[self class] allObjects];
    
    __block NSArray *fetchedObjectsWithUidsInremoteIds;
    
    __block float total = objects.count;
    __block float count = total;
    
    [childContext performBlockAndWait:^{
        /*
        for (NSDictionary *objectDict in objects) {
            NSManagedObject *object = [self upsertObjectWithDictionary:objectDict uid:objectDict[uniqueIdentifierName] inManagedObjectContext:childContext];
            [newObjects addObject:[object mainContextObject]];
            
            count--;
            *outProgress = (total - count) / total;
        }
         */
        fetchedObjectsWithUidsInremoteIds = [self updatedWithObjects:objects context:childContext];
    }];
    
//    NSMutableSet *deleteObjects = [NSMutableSet setWithArray:allObjects];
//    [deleteObjects minusSet:[NSSet setWithArray:newObjects]];
    
    NSError *error = nil;
    if (outError != NULL) {
        error = *outError;
    }
    if (![NSManagedObject saveContextAndWait:childContext error:&error]) {
        NSLog(@"Core Data Save Error: %@, %@", self, [error localizedDescription]);
    }
    
    return fetchedObjectsWithUidsInremoteIds;
}

+ (void)batchUpdateObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName completion:(void(^)(NSArray *results, NSError *error))completion
{
    return [self batchUpdateObjects:objects uniqueIdentifierName:uniqueIdentifierName progress:nil completion:completion];
}

+ (void)batchUpdateObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName progress:(void(^)(CGFloat progress))progress completion:(void(^)(NSArray *results, NSError *error))completion
{
    
    
    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    childContext.parentContext = [NSManagedObject mainContext];
    
    [childContext performBlock:^{
        /*
        NSArray *sortedRemoteObjects = [objects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 valueForKey:uniqueIdentifierName] compare:[obj2 valueForKey:uniqueIdentifierName]];
        }];
//        NSArray *remoteUids = [[objects valueForKey:uniqueIdentifierName] sortedArrayUsingSelector:@selector(compare:)];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity: [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:childContext]];
//        [fetchRequest setPredicate: [NSPredicate predicateWithFormat:@"(%K IN %@)", uniqueIdentifierName, remoteUids]];
        
        // make sure the results are sorted as well
        [fetchRequest setSortDescriptors: @[[[NSSortDescriptor alloc] initWithKey:uniqueIdentifierName ascending:YES]]];
        
        NSError *error;
        NSArray *sortedFetchedObjects = [childContext executeFetchRequest:fetchRequest error:&error];
        
        __block NSUInteger fetchedObjectsIndex = 0;
        [sortedRemoteObjects enumerateObjectsUsingBlock:^(NSDictionary *remoteObject, NSUInteger idx, BOOL *stop) {
            NSString *remoteUid = [remoteObject valueForKey:uniqueIdentifierName];
            NSString *localUid = [sortedFetchedObjects[fetchedObjectsIndex] valueForKey:[self uniqueIdentifierKey]];
            
            if ([remoteUid isKindOfClass:[NSNumber class]]) {
                remoteUid = [(NSNumber *)remoteUid stringValue];
            }
            
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteUid == %@", localUid];
            NSComparisonResult comparison = [remoteUid compare:localUid];
            
            // reached end of fetchedObjects, the rest of the remoteUids from list should be added as new objects
            if (fetchedObjectsIndex > sortedFetchedObjects.count) {
                comparison = NSOrderedAscending;
            }
            
            if (comparison == NSOrderedSame) { // same uids from both lists, update
                //update
                [sortedFetchedObjects[fetchedObjectsIndex] updateWithAndRemoveNullsFromDictionary:remoteObject];
                fetchedObjectsIndex++;
            } else if (comparison == NSOrderedAscending) { // remoteUid not in fetchedObjects, new object
                // new
                id object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:childContext];
                [object updateWithAndRemoveNullsFromDictionary:remoteObject];
            } else { // delete until next local object uid matches current remote uid
                NSComparisonResult comparison;
                while (comparison == NSOrderedDescending) {
                    [childContext deleteObject:sortedFetchedObjects[fetchedObjectsIndex]];
                    fetchedObjectsIndex++;
                    NSString *localUid = [sortedFetchedObjects[fetchedObjectsIndex] uniqueIdentifierKey];
                    comparison = [remoteUid compare:localUid];
                }
            }
        }];
        
//        NSArray *remoteUids = [objects valueForKey:uniqueIdentifierName];
//        NSArray *fetchedObjectsWithUidsInremoteIds = [sortedFetchedObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(%K IN %@)", uniqueIdentifierName, remoteUids]];
//        
//        NSMutableArray *newObjects = [NSMutableArray array];
//        NSArray *allObjects = [[self class] allObjects];
//        
//        float total = objects.count;
//        float count = total;
//        
//        for (NSDictionary *objectDict in objects) {
//            NSManagedObject *object = [self upsertObjectWithDictionary:objectDict uid:objectDict[uniqueIdentifierName] inManagedObjectContext:childContext];
//            [newObjects addObject:[object mainContextObject]];
//            
//            count--;
//            float percent = (total - count) / total;
//            if (progress) {
//                progress(percent);
//            }
//        }
//        
//        NSMutableSet *deleteObjects = [NSMutableSet setWithArray:allObjects];
//        [deleteObjects minusSet:[NSSet setWithArray:newObjects]];
        */
        NSArray *fetchedObjectsWithUidsInremoteIds = [self updatedWithObjects:objects context:childContext];
        
        [NSManagedObject saveContext:childContext completion:^(NSError *error) {
            if (error) {
                NSLog(@"Core Data Save Error: %@, %@", self, error.localizedDescription);
            }
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(fetchedObjectsWithUidsInremoteIds, error);
                });
            }
        }];
    }];
}

+ (NSArray *)updatedWithObjects:(NSArray *)objects context:(NSManagedObjectContext *)context
{
    NSArray *sortedObjects = [objects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 valueForKey:[self uniqueIdentifierKey]] compare:[obj2 valueForKey:[self uniqueIdentifierKey]]];
    }];
    NSMutableArray *remoteUids = [NSMutableArray array];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity: [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context]];
    //        [fetchRequest setPredicate: [NSPredicate predicateWithFormat:@"(%K IN %@)", uniqueIdentifierName, remoteUids]];
    
    // make sure the results are sorted as well
    [fetchRequest setSortDescriptors: @[[[NSSortDescriptor alloc] initWithKey:@"uid" ascending:YES]]];
    
    NSError *error;
    NSArray *sortedManagedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    __block NSUInteger index = 0;
    [sortedObjects enumerateObjectsUsingBlock:^(NSDictionary *remoteObject, NSUInteger idx, BOOL *stop) {
        NSComparisonResult comparison;
        

        NSString *remoteUid = [remoteObject valueForKey:[self uniqueIdentifierKey]];
        
        if ([remoteUid isKindOfClass:[NSNumber class]]) {
            remoteUid = [(NSNumber *)remoteUid stringValue];
        }
        
        [remoteUids addObject:remoteUid];
        
        /*
         if ([remoteUid isKindOfClass:[NSNumber class]]) {
         remoteUid = [obj stringValue];
         }
         */
        //            if ([[objectsMatchingRemoteIds[idx] uid] isKindOfClass:[NSNumber class]]) {
        //                localUid = [[objectsMatchingRemoteIds[idx] uid] stringValue];
        //            }
        
        //            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteUid == %@", localUid];
        
        
        // reached end of sortedManagedObjects, the rest of the remoteUids from list should be added as new objects
        if (index > sortedManagedObjects.count - 1) {
            comparison = NSOrderedAscending;
        } else {
            NSString *localUid = [sortedManagedObjects[index] valueForKey:@"uid"];
            comparison = [remoteUid compare:localUid];
            
            // check for duplicates
            if (index > 0 && [[sortedManagedObjects[index - 1] uid] compare:[sortedManagedObjects[index] uid]] == NSOrderedSame) {
                NSLog(@"More than one %@ object with unique id not expected", self);
            }
        }
        
        if (comparison == NSOrderedSame) { // same uids from both lists, update
            //update
            [sortedManagedObjects[index] updateWithAndRemoveNullsFromDictionary:remoteObject];
            index++;
        } else if (comparison == NSOrderedAscending) { // remoteUid not in fetchedObjects, new object
            // new
            id object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
            [object updateWithAndRemoveNullsFromDictionary:remoteObject];
        } else { // delete until next local object uid matches current remote uid
            while (comparison == NSOrderedDescending && index < sortedManagedObjects.count) {
                [context deleteObject:sortedManagedObjects[index]];
                index++;
                if (index < sortedManagedObjects.count) {
                    NSString *localUid = [sortedManagedObjects[index] uid];
                    comparison = [remoteUid compare:localUid];
                } else {
                    comparison = NSOrderedAscending;
                }
            }
            
            if (comparison == NSOrderedSame) {
                [sortedManagedObjects[index] updateWithAndRemoveNullsFromDictionary:remoteObject];
            }
            
            if (comparison == NSOrderedAscending) { // remoteUid not in fetchedObjects, new object
                // new
                id object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
                [object updateWithAndRemoveNullsFromDictionary:remoteObject];
            }
        }
    }];
    
    NSArray *fetchedObjectsWithUidsInremoteIds = [sortedManagedObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(%K IN %@)", @"uid", remoteUids]];
    
    NSMutableArray *mainContextObjects = [NSMutableArray array];
    for (NSManagedObject *object in fetchedObjectsWithUidsInremoteIds) {
        [mainContextObjects addObject:[[self mainContext] objectWithID:object.objectID]];
    }
    
    return mainContextObjects;
}

@end