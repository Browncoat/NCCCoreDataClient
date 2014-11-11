//
//  User+Request.m
//  iOS
//
//  Created by Nathaniel Potter on 11/1/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "User+Request.h"
#import "Media.h"

@implementation User (Request)

+ (void)initialize
{
    [self setBasePath:@"https://api.instagram.com/v1/users/"];
}

+ (void)GETUserWithName:(NSString *)name completion:(void(^)(User *user, NSError *error))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    
    [self GET:[NSString stringWithFormat:@"search?q=%@&access_token=%@", name, token] uidKey:@"id" progress:^(CGFloat progress) {
        NSLog(@"progress:%f", progress);
    } withCompletion:^(NSArray *results, NSError *error) {
        NSLog(@"%@", results);
        User *user = results[0];
        completion(user, error);
    }];
}



@end

