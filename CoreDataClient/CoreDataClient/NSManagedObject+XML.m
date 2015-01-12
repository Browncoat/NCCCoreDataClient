//
//  NSManagedObject+XML.m
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import "NSManagedObject+XML.h"
#import "NCCCoreDataClient.h"

@implementation NSManagedObject (XML)

+ (instancetype)upsertObjectWithRXMLElement:(RXMLElement *)element uid:(NSString *)uid inManagedObjectContext:(NSManagedObjectContext *)context
{
    id object = nil;
    
    if (uid) {
        // look for object in child context
        object = [[self class] objectWithId:uid inManagedObjectContext:context];
        
        // look for object in main context
        if (!object) {
            object = [[self class] objectWithId:uid];
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
    id object = [NSEntityDescription insertNewObjectForEntityForName:self.classNameWithoutNamespace inManagedObjectContext:context];
    
    [object updateWithRXMLElement:element];
    
    return object;
}

- (void)updateWithRXMLElement:(RXMLElement *)element
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
