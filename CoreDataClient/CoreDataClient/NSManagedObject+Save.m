//
//  NSManagedObject+Save.m
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import "NSManagedObject+Save.h"
#import "NCCCoreDataClient.h"

@implementation NSManagedObject (Save)

+ (BOOL)saveContextAndWait:(NSManagedObjectContext *)context error:(NSError **)saveError
{
    __block BOOL success = NO;
    
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
        success = (context != nil);
        NSError *error;
        if (!success) {
            error = [NSError errorWithDomain:@"com.ncccoredataclient" code:0 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@: mangedObjectContext is nil, you must set it's managedObjectContext property in order to save", self]}];
        }
    }
    
    return success;
}

+ (void)saveContext:(NSManagedObjectContext *)context completion:(void(^)(NSError *error))completion
{
    if ([context hasChanges]) {
        [context performBlock:^{
            NSError *saveError = nil;
            BOOL success = [context save:&saveError];
            if (success) {
                // recursively save up the context chain
                if (context.parentContext) {
                    [self saveContext:context.parentContext completion:completion];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(saveError);
                        }
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(saveError);
                    }
                });
            }
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            if (!context) {
                error = [NSError errorWithDomain:@"com.ncccoredataclient" code:0 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@: mangedObjectContext is nil, you must set it's managedObjectContext property in order to save", self]}];
            }
            if (completion) {
                completion(error);
            }
        });
    }
}

- (void)saveWithError:(NSError **)saveError
{
    [[self class] saveContextAndWait:self.managedObjectContext error:saveError];
}

- (void)saveWithCompletion:(void(^)(NSError *error))completion
{
    [[self class] saveContext:self.managedObjectContext completion:completion];
}

// Helpers



+ (NSManagedObjectContext *)saveToDiskContext
{
    return [[UIApplication sharedApplication] privateSaveToDiskContext];
}

@end
