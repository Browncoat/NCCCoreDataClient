//
//  NSManagedObject+Utilities.m
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import "NSManagedObject+Utilities.h"
#import "NCCCoreDataClient.h"

id (^if_value_action_else_nil)(id value, SEL action) = ^ id (id value, SEL action) {
    if (value == [NSNull null]) {
        return nil;
    } else {
        if (action) {
            return [value performSelector:action];
        }
        return value;
    }
};

id (^if_value_else_nil)(id value) = ^ id (id value) {
    return if_value_action_else_nil(value, nil);
};

@implementation NSManagedObject (Utilities)

//swift classes are namespaced
+ (NSString *)classNameWithoutNamespace
{
    return [[NSStringFromClass([self class]) componentsSeparatedByString:@"."] lastObject];
}

- (NSManagedObjectContext *)mainContext
{
    return [NSManagedObjectContext mainContext];
}

@end
