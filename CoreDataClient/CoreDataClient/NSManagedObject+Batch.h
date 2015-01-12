//
//  NSManagedObject+Batch.h
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface NSManagedObject (Batch)

+ (NSArray *)batchUpdateAndWaitObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName error:(NSError **)outError;
+ (NSArray *)batchUpdateAndWaitObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName progress:(CGFloat *)outProgress error:(NSError **)error;

+ (void)batchUpdateObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName completion:(void(^)(NSArray *results, NSError *error))completion;
+ (void)batchUpdateObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName progress:(void(^)(CGFloat progress))progress completion:(void(^)(NSArray *results, NSError *error))completion;

@end
