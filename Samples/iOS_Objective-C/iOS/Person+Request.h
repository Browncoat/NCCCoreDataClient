//
//  Person+Request.h
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 11/4/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "Person.h"

@interface Person (Request)

+ (void)personWithId:(NSString *)uid completion:(void(^)(Person *persom, NSError *error))completion;

@end
