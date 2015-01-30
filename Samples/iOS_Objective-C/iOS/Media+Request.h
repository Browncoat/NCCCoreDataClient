//
//  Media+Request.h
//  RESTfulCoreDataSample
//
//  Created by Nathaniel Potter on 11/1/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "Media.h"

@interface Media (Request)

+ (void)GETPopularWithCompletion:(void(^)(NSArray *results, NSError *error))completion;
+ (void)GETRecentMediaForUserId:(NSString *)userId withCompletion:(void(^)(NSArray *results, NSError *error))completion;

@end
