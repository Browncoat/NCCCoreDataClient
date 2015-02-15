//
//  NSManagedObject+RequestAdapter.m
//  RESTfulCoreDataSample
//
//  Created by Nathaniel Potter on 11/1/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "NSManagedObject+RequestAdapter.h"

@implementation NSManagedObject (RequestAdapter)

+ (void)makeRequest:(NSMutableURLRequest *)request progress:(void(^)(CGFloat progress))progressBlock completion:(void(^)(NSArray *results, NSError *error))completion
{
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:ClientAuthTokenKey];
    [request setHeaders:@{@"Authorization":[NSString stringWithFormat:@"Bearer %@", token]}];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Error: %@", connectionError);
            completion(nil, connectionError);
        } else {
            NSError *error;
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                completion(nil, error);
            } else {
                NSLog(@"JSON: %@", responseObject);
                if (![responseObject isKindOfClass:[NSArray class]]) {
                    responseObject = @[responseObject];
                }
                completion(responseObject, nil);
            }
        }
    }];
}

@end
