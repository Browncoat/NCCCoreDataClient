//
//  Moment+Request.h
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 11/4/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "Moment.h"

@interface Moment (Request)

- (void)saveWithCompletion:(void(^)(Moment *moment, NSError *error))completion;

@end
