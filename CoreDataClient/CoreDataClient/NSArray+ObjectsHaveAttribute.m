//
//  NSArray+ObjectsHaveAttribute.m
//  paperwoven
//
//  Created by Nate Potter on 2/18/15.
//  Copyright (c) 2015 OutCoursing. All rights reserved.
//

#import "NSArray+ObjectsHaveAttribute.h"

@implementation NSArray (ObjectsHaveAttribute)

- (BOOL)allObjectsHaveAttribute:(NSString *)attribute
{
    BOOL objectsHaveAttribute = NO;
    if (self.count) {
        NSMutableArray *attributes = [NSMutableArray arrayWithArray:[self valueForKey:attribute]];
        [attributes removeObject:[NSNull null]];
        objectsHaveAttribute = attributes.count == self.count;
    }
    
    return objectsHaveAttribute;
}

@end
