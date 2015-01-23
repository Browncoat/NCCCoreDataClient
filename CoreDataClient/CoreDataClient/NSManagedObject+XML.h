//
//  NSManagedObject+XML.h
//  Mind-Over-Mood
//
//  Created by Nathaniel Potter on 1/11/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

#import <CoreData/CoreData.h>
@class RXMLElement;

@interface NSManagedObject (XML)

+ (instancetype)upsertObjectWithRXMLElement:(RXMLElement *)element uid:(NSString *)uid inManagedObjectContext:(NSManagedObjectContext *)context;
+ (instancetype)insertObjectWithRXMLElement:(RXMLElement *)element inManagedObjectContext:(NSManagedObjectContext *)context;

- (void)updateWithRXMLElement:(RXMLElement *)element;

@end
