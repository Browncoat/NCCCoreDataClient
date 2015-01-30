//
//  Comment+JSON.m
//  RESTfulCoreDataSample
//
//  Created by Nathaniel Potter on 11/2/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "Comment+JSON.h"
#import "User.h"

static NSDateFormatter *_dateFormatter;

@implementation Comment (JSON)

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    self.id = dictionary[@"id"];
    self.text = dictionary[@"text"];
    
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"";
    }
    self.createdTime = [_dateFormatter dateFromString:dictionary[@"created_time"]];
    
    self.from = [User upsertObjectWithDictionary:dictionary[@"from"] uid:dictionary[@"from"][@"id"] inManagedObjectContext:self.managedObjectContext];
}

@end
