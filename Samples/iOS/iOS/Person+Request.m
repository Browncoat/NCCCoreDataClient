//
//  Person+Request.m
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 11/4/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "Person+Request.h"

@implementation Person (Request)

+ (void)initialize
{
    [self setBasePath:@"https://www.googleapis.com/plus/v1/people/"];
}

+ (void)personWithId:(NSString *)uid completion:(void(^)(Person *person, NSError *error))completion
{
    [self GET:uid progress:nil request:nil withCompletion:^(NSArray *results, NSError *error) {
        completion(results.lastObject, error);
    }];
}

@end
