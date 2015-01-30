//
//  Comment+Request.h
//  RESTfulCoreDataSample
//
//  Created by Nathaniel Potter on 11/2/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "Comment.h"
@class Media;

@interface Comment (Request)

- (void)POSTCommentToMedia:(Media *)media withCompletion:(void(^)(NSArray *results, NSError *error))completion;

@end
