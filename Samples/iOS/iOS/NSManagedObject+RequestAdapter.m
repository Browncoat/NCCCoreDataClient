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
 + (void)makeRequest:(NSURLRequest *)request withCompletion:(void(^)(id results, NSError *error))completion
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

+ (void)makeRequest:(NSURLRequest *)request progress:(void(^)(CGFloat progress))progressBlock withCompletion:(void(^)(id results, NSError *error))completion
{
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

/*
+ (void)makeRequest:(NSURLRequest *)request withCompletion:(void(^)(id results, NSError *error))completion
{
    _HTTPClient = [NCCHTTPClient clientWithRequest:request];
    [_HTTPClient GETWithCompletion:^(NSData *data, NSError *error) {
        if (!error) {
            NSError *error;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                completion(array, error);
            }
        }
    }];
}
*/

@end
