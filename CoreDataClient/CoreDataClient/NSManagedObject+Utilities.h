//
//  NSManagedObject+Utilities.h
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import <CoreData/CoreData.h>

id (^if_value_else_nil)(id value);
id (^if_value_action_else_nil)(id value, SEL action);

@interface NSManagedObject (Utilities)

+ (NSString *)classNameWithoutNamespace;

@end
