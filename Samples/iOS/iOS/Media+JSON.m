//
//  Media+JSON.m
//  RESTfulCoreDataSample
//
//  Created by Nathaniel Potter on 11/1/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "Media+JSON.h"

@implementation Media (JSON)

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    self.uid = dictionary[@"id"]; // require uid
    self.type = dictionary[@"type"];
    self.link = dictionary[@"link"];
}

@end
