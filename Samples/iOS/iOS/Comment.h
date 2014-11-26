//
//  Comment.h
//  RESTfulCoreDataSample
//
//  Created by Nathaniel Potter on 11/2/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSDate * createdTime;
@property (nonatomic, retain) User *from;

@end
