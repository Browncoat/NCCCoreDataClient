//
//  NSManagedObject+JSON.h
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (JSON)

+ (instancetype)upsertObjectWithDictionary:(NSDictionary *)dictionary uid:(NSString *)uid inManagedObjectContext:(NSManagedObjectContext *)context;
+ (instancetype)insertObjectWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)context;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

@end
