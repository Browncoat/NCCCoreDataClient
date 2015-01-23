//
//  NSManagedObject+Fetch.h
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Fetch)

+ (NSArray *)allObjects;

+ (NSArray *)allObjectsInManagedObjectContext:(NSManagedObjectContext *)context;

+ (instancetype)objectWithId:(id)uid;

+ (instancetype)objectWithId:(id)uid inManagedObjectContext:(NSManagedObjectContext *)context;

- (instancetype)mainContextObject;

@end
