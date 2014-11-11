//
//  Comment+Request.m
//  RESTfulCoreDataSample
//
//  Created by Nathaniel Potter on 11/2/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "Comment+Request.h"
#import "Media.h"

@implementation Comment (Request)

+ (void)initialize
{
    [self setBasePath:@"https://api.instagram.com/v1/media/"];
}

- (void)POSTCommentToMedia:(Media *)media withCompletion:(void(^)(NSArray *results, NSError *error))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];
    
    [self POST:[NSString stringWithFormat:@"%@/%@", media.uid, @"comments"] request:^(NSMutableURLRequest *request) {
        NSData *formData = [[NSString stringWithFormat:@"access_token=%@&text=%@", token, @"Hellllloooooo"] dataUsingEncoding:NSUTF8StringEncoding];
        [request setData:formData ofContentType:postBodyContentTypeData];
    } withCompletion:^(id results, NSError *error) {
        completion(results, error);
    }];
}

@end
