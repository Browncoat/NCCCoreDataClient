//
//  User+Request.h
//  iOS
//
//  Created by Nathaniel Potter on 11/1/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "User.h"

@interface User (Request)

+ (void)GETUserWithName:(NSString *)name completion:(void(^)(User *user, NSError *error))completion;

@end
