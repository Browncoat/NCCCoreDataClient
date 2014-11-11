//
//  Moment+JSON.m
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 11/4/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "Moment+JSON.h"

@implementation Moment (JSON)

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    self.uid = dictionary[@"id"];
    self.kind = dictionary[@"kind"];
    self.title = dictionary[@"title"];
}

@end
