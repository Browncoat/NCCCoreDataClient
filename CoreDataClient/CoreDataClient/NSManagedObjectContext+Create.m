//
//  NSManagedObjectContext+Create.m
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import "NSManagedObjectContext+Create.h"

@implementation NSManagedObjectContext (Create)

- (instancetype)childManagedObjectContext
{
    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    childContext.parentContext = self;
    
    return childContext;
}

@end
