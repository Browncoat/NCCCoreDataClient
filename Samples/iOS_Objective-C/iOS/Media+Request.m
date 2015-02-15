//
//  Media+Request.m
//  RESTfulCoreDataSample
//
//  Created by Nathaniel Potter on 11/1/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "Media+Request.h"

@implementation Media (Request)

+ (void)initialize
{
    [self setBasePath:@"https://api.instagram.com/v1/media/"]; // requires trailing slash
}

+ (void)GETPopularWithCompletion:(void(^)(NSArray *results, NSError *error))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    if (!token) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Token" message:@"No Access Token" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    [self GET:[NSString stringWithFormat:@"popular?&access_token=%@", token] progress:^(CGFloat progress) {
        NSLog(@"progress:%f", progress);
    } withCompletion:^(NSArray *results, NSError *error) {
        NSLog(@"%@", results);
        completion(results, error);
    }];
}

+ (void)GETRecentMediaForUserId:(NSString *)userId withCompletion:(void(^)(NSArray *results, NSError *error))completion
{
    NSString *instagramClientId = [[NSUserDefaults standardUserDefaults] valueForKey:@"instagram_client_id"];
    
    [self GET:[NSString stringWithFormat:@"%@/media/recent/?client_id=%@", userId, instagramClientId] progress:^(CGFloat progress) {
        NSLog(@"progress:%f", progress);
    } withCompletion:^(NSArray *results, NSError *error) {
        NSLog(@"%@", results);
        completion(results, error);
    }];
}

@end
