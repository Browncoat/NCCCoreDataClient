//
//  NSManagedObject+JSON.m
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import "NSManagedObject+JSON.h"
#import "NCCCoreDataClient.h"

@implementation NSManagedObject (JSON)

+ (instancetype)upsertObjectWithDictionary:(NSDictionary *)dictionary uid:(id)uid inManagedObjectContext:(NSManagedObjectContext *)context
{
    id object = nil;
    
    if (uid) {
        object = [[self class] objectWithId:uid inManagedObjectContext:context];
    }
    
    if (object) {
        // reference object by ID to prevent context errors
        object = [[NSManagedObjectContext mainContext] objectWithID:[object objectID]];
        
        [context performBlockAndWait:^{
            // update object on child context
            [object updateWithDictionary:dictionary];
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
        
        object = [NSEntityDescription insertNewObjectForEntityForName:self.classNameWithoutNamespace inManagedObjectContext:context];
        
        [object updateWithDictionary:dictionary];
    }];
    
    return object;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in the %@ class", NSStringFromSelector(_cmd), NSStringFromClass([self class])]
                                 userInfo:nil];
}

@end
