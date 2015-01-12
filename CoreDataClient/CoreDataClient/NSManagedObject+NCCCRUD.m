// NSManagedObject+NCCCRUD.m
//
// Copyright (c) 2013-2014 NCCCoreDataClient (http://coredataclient.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSManagedObject+NCCCRUD.h"
#import "UIApplication+NCCCoreData.h"
#import "NSManagedObject+NCCRequest.h"


@implementation NSManagedObject (NCCCRUD)

// XML



#pragma mark - Update JSON


/*
- (void)clearAllProperties
{
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        //        NSString *attributesString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
        
        //        NSLog(@"Property %@ attributes: %@", name, attributesString);
        
        id valueForProperty = [self valueForKey:name];
        if ([valueForProperty isKindOfClass:[NSSet class]]) {
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@%@:", @"remove", [name capitalizedString]]);
            IMP imp = [self methodForSelector:selector];
            void (*func)(id, SEL, NSSet *) = (void *)imp;
            func(self, selector, valueForProperty);
            //            [self performSelector:selector withObject:valueForProperty];
        } else if ([valueForProperty isKindOfClass:[NSObject class]]) {
            valueForProperty = nil;
        } else {
            valueForProperty = 0;
        }
    }
    
    free(propertyArray);
}
*/

#pragma mark - Create


/*
+ (NSManagedObjectContext *)tempContext
{
    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    childContext.parentContext = [self mainContext];
    
    return childContext;
}
 */

@end