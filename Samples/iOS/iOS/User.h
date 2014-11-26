//
//  User.h
//  iOS
//
//  Created by Nathaniel Potter on 11/1/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * profilePicturePath;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * website;

@end
