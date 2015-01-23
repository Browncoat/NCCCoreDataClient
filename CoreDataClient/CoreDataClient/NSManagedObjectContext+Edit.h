//
//  NSManagedObjectContext+Edit.h
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Edit)

- (NSManagedObject *)editObject:(NSManagedObject *)managedObject;

@end
