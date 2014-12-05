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
    [request setPropertiesToFetch:@[[self managedObjectUidKey]]];
    
    // Execute the fetch.
    NSError *error;
    NSArray *uids = [[context executeFetchRequest:request error:&error] valueForKey:[self managedObjectUidKey]];
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
                [context deleteObject:[context objectWithID:object.objectID]];
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
    NSSet *duplicateObjects = [NSSet setWithArray:[[object class] managedObjectsWithId:[object valueForKey:[self managedObjectUidKey]]]];
    
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

+ (void)batchUpdateObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName completion:(void(^)(NSArray *results, NSError *error))completion
{
    return [self batchUpdateObjects:objects uniqueIdentifierName:uniqueIdentifierName progress:nil completion:completion];
}

+ (void)batchUpdateObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName progress:(void(^)(CGFloat progress))progress completion:(void(^)(NSArray *results, NSError *error))completion
{
    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    childContext.parentContext = [NSManagedObject mainContext];
    
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

+ (NSArray *)managedObjectsWithResponseObjects:(NSArray *)objects context:(NSManagedObjectContext *)context progress:(void(^)(CGFloat progress))progress
{
    NSMutableArray *responseUids = [NSMutableArray arrayWithArray:[objects valueForKey:[self responseObjectUidKey]]];
    [responseUids removeObject:[NSNull null]];
    BOOL objectsHaveUidAttribute = responseUids.count == objects.count;
    if (objectsHaveUidAttribute) {
        NSMutableArray *upsertedObjects = [NSMutableArray array];
        
        NSArray *sortedResponseObjects = [objects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            id id1 = [obj1 valueForKey:[self responseObjectUidKey]];
            id id2 = [obj2 valueForKey:[self responseObjectUidKey]];
            if ([id1 respondsToSelector:@selector(compare:options:)]) {
                return [id1 compare:id2 options:NSNumericSearch]; // NSNumericSearch in case values are strings
            }
            return [id1 compare:id2];
        }];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity: [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context]];
        // make sure the results are sorted as well
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[self managedObjectUidKey] ascending:YES comparator:^NSComparisonResult(id id1, id id2) {
            if ([id1 respondsToSelector:@selector(compare:options:)]) {
                return [id1 compare:id2 options:NSNumericSearch]; // NSNumericSearch in case values are strings
            }
            return [id1 compare:id2];
        }];
        NSError *error;
        NSArray *sortedManagedObjects = [[context executeFetchRequest:fetchRequest error:&error] sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        __block NSUInteger index = 0;
        [sortedResponseObjects enumerateObjectsUsingBlock:^(NSDictionary *responseObject, NSUInteger idx, BOOL *stop) {
            NSComparisonResult comparison;

            BOOL reachedEndOfLocalManagedObjects = sortedManagedObjects.count == 0 || index > sortedManagedObjects.count - 1;
            if (reachedEndOfLocalManagedObjects) {
                comparison = NSOrderedAscending; // NEW Objects
            } else {
                // compare local and remote ids (make them the same type, NSString)
                id remoteUid = [responseObject valueForKey:[self responseObjectUidKey]];
                if ([remoteUid isKindOfClass:[NSNumber class]]) {
                    remoteUid = [remoteUid stringValue];
                }
                id localUid = [sortedManagedObjects[index] valueForKey:[self managedObjectUidKey]];
                if ([localUid isKindOfClass:[NSNumber class]]) {
                    localUid = [localUid stringValue];
                }
                comparison = [remoteUid compare:localUid options:NSNumericSearch]; // NSNumericSearch in case values are strings
                
                // check for duplicates
                if (index > 0 && [[sortedManagedObjects[index - 1] valueForKey:[self managedObjectUidKey]] compare:[sortedManagedObjects[index] valueForKey:[self managedObjectUidKey]]] == NSOrderedSame) {
                    NSLog(@"More than one %@ object with unique id not expected", self);
                }
            }
            
            if (comparison == NSOrderedSame) { // same uids from both lists, UPDATE
                NSManagedObject *object = sortedManagedObjects[index];
                [object updateWithAndRemoveNullsFromDictionary:responseObject];
                [upsertedObjects addObject:[object mainContextObject]];
                index++;
            } else if (comparison == NSOrderedAscending) { // remoteUid not in fetchedObjects, NEW
                // new
                NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
                [object updateWithAndRemoveNullsFromDictionary:responseObject];
                [upsertedObjects addObject:[object mainContextObject]];
            } else { // localUid not in remoteObjects, delete until next local object uid matches current remote uid, DELETE
                while (comparison == NSOrderedDescending && index < sortedManagedObjects.count) {
                    [context deleteObject:sortedManagedObjects[index]];
                    index++;
                    if (index < sortedManagedObjects.count) {
                        id remoteUid = [responseObject valueForKey:[self responseObjectUidKey]];
                        if ([remoteUid isKindOfClass:[NSNumber class]]) {
                            remoteUid = [remoteUid stringValue];
                        }
                        id localUid = [sortedManagedObjects[index] valueForKey:[self managedObjectUidKey]];
                        if ([localUid isKindOfClass:[NSNumber class]]) {
                            localUid = [localUid stringValue];
                        }
                        comparison = [remoteUid compare:localUid options:NSNumericSearch]; // NSNumericSearch in case values are strings
                    } else {
                        comparison = NSOrderedAscending;
                    }
                }
                
                if (comparison == NSOrderedSame) {
                    NSManagedObject *object = sortedManagedObjects[index];
                    [object updateWithAndRemoveNullsFromDictionary:responseObject];
                    [upsertedObjects addObject:[object mainContextObject]];
                    index++;
                }
                
                if (comparison == NSOrderedAscending) { // remoteUid not in fetchedObjects, new object
                    // new
                    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
                    [object updateWithAndRemoveNullsFromDictionary:responseObject];
                    [upsertedObjects addObject:[object mainContextObject]];
                }
            }
            
            if (progress) {
                float percent = (float)idx / (float)sortedResponseObjects.count;
                progress(percent);
            }
        }];
        
        // DELETE local objects that are beyond end of remote objects array
        BOOL reachedEndOfRemoteObjects = sortedResponseObjects.count == 0 || index > sortedResponseObjects.count - 1;
        if (reachedEndOfRemoteObjects) {
            while (index < sortedManagedObjects.count) {
                [context deleteObject:sortedManagedObjects[index]];
                index++;
            }
        }
        
        return upsertedObjects;
    }
    
    NSMutableArray *newObjects = [NSMutableArray array];
    [objects enumerateObjectsUsingBlock:^(NSDictionary *responseObject, NSUInteger idx, BOOL *stop) {
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
        [object updateWithAndRemoveNullsFromDictionary:responseObject];
        [newObjects addObject:[object mainContextObject]];
        
        if (progress) {
            float percent = (float)idx / (float)objects.count;
            progress(percent);
        }
    }];
    
    return newObjects;
}

@end