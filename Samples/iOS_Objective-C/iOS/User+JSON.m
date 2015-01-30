//
//  User+JSON.m
//  iOS
//
//  Created by Nathaniel Potter on 11/1/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "User+JSON.h"

@implementation User (JSON)

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    self.id = dictionary[@"id"];
    self.bio = dictionary[@"bio"];
    self.profilePicturePath = dictionary[@"profile_picture"];
    self.userName = dictionary[@"username"];
    self.website = dictionary[@"website"];
}

@end
