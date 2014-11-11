//
//  Person+JSON.m
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 11/4/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "Person+JSON.h"

@implementation Person (JSON)

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    self.uid = dictionary[@"id"];
    self.displayName = dictionary[@"displayName"];
    self.url = dictionary[@"url"];
}

@end
