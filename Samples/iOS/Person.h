//
//  Person.h
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 11/4/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * url;

@end
