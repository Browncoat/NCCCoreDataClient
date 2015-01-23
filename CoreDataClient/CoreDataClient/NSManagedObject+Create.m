//
//  NSManagedObject+Create.m
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import "NSManagedObject+Create.h"
#import "NCCCoreDataClient.h"

@implementation NSManagedObject (Create)

+ (instancetype)tempObject
{
    return [self objectInManagedObjectContext:nil];
}

+ (instancetype)objectInManagedObjectContext:(NSManagedObjectContext *)context;
{
    return [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:self.classNameWithoutNamespace inManagedObjectContext:[NSManagedObjectContext mainContext]] insertIntoManagedObjectContext:context];
}

@end
