//
//  NSManagedObjectContext+Edit.m
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import "NSManagedObjectContext+Edit.h"

@implementation NSManagedObjectContext (Edit)

- (NSManagedObject *)editObject:(NSManagedObject *)managedObject
{
    return [self objectWithID:managedObject.objectID];
}

@end
