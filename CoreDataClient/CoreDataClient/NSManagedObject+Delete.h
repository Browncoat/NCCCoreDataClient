//
//  NSManagedObject+Delete.h
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Delete)

+ (void)deleteObjects:(NSSet *)deleteSet;
+ (void)deleteObjects:(NSSet *)deleteSet inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteObject:(NSManagedObject *)object;
+ (void)deleteObject:(NSManagedObject *)object inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteAllObjects;
+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteObjectWithId:(NSString *)uid;
+ (void)deleteObjectWithId:(NSString *)uid inManagedObjectContext:(NSManagedObjectContext *)context;

@end
