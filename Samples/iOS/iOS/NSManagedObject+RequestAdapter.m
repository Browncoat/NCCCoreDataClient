//
//  NSManagedObject+RequestAdapter.m
//  RESTfulCoreDataSample
//
//  Created by Nathaniel Potter on 11/1/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "NSManagedObject+RequestAdapter.h"
#import <AFNetworking/AFNetworking.h>

@implementation NSManagedObject (RequestAdapter)

/*
 + (void)makeRequest:(NSURLRequest *)request completion:(void(^)(NSArray *results, NSError *error))completion
 {
 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
 NSURLResponse *response;
 NSError *error;
 NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 if (!error) {
 NSError *error;
 NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
 completion(results, error);
 } else {
 completion(nil, error);
 }
 }];
 }
 */

+ (void)makeRequest:(NSMutableURLRequest *)request progress:(void(^)(CGFloat progress))progressBlock completion:(void(^)(NSArray *results, NSError *error))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:ClientAuthTokenKey];
    [request setHeaders:@{@"Authorization":[NSString stringWithFormat:@"Bearer %@", token]}];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if (![responseObject isKindOfClass:[NSArray class]]) {
            responseObject = @[responseObject];
        }
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

@end
