//
//  NSManagedObject+Save.h
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Save)

+ (BOOL)saveContextAndWait:(NSManagedObjectContext *)context error:(NSError **)saveError;
+ (void)saveContext:(NSManagedObjectContext *)context completion:(void(^)(NSError *error))completion;

- (void)saveWithError:(NSError **)saveError;
- (void)saveWithCompletion:(void(^)(NSError *error))completion;

@end
