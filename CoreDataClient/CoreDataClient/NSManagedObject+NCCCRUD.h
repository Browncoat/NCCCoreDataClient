// NSManagedObject+NCCCRUD.h
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

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class RXMLElement;

id (^if_value_else_nil)(id value);
id (^if_value_action_else_nil)(id value, SEL action);

@interface NSManagedObject (NCCCRUD)

// CREATING FROM XML
+ (instancetype)upsertObjectWithRXMLElement:(RXMLElement *)element uid:(NSString *)uid inManagedObjectContext:(NSManagedObjectContext *)context;

+ (instancetype)insertObjectWithRXMLElement:(RXMLElement *)element inManagedObjectContext:(NSManagedObjectContext *)context;

- (void)updateWithRXMLElement:(RXMLElement *)element;

// CREATING FROM JSON
+ (instancetype)PUT:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)context;
+ (instancetype)PUT:(NSDictionary *)dictionary;
+ (instancetype)upsertObjectWithDictionary:(NSDictionary *)dictionary uid:(NSString *)uid inManagedObjectContext:(NSManagedObjectContext *)context;

+ (instancetype)POST:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)context;
+ (instancetype)POST:(NSDictionary *)dictionary;
+ (instancetype)insertObjectWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)context;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

// Temp Object
+ (instancetype)objectInManagedObjectContext:(NSManagedObjectContext *)context;

//DELETING
+ (void)deleteObjects:(NSSet *)deleteSet;
+ (void)deleteObjects:(NSSet *)deleteSet inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteObject:(NSManagedObject *)object;
+ (void)deleteObject:(NSManagedObject *)object inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteAllObjects;
+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteObjectWithId:(NSString *)uid;
+ (void)deleteObjectWithId:(NSString *)uid inManagedObjectContext:(NSManagedObjectContext *)context;

// SAVING
+ (BOOL)saveContextAndWait:(NSManagedObjectContext *)context error:(NSError **)saveError;

+ (void)saveContext:(NSManagedObjectContext *)context completion:(void(^)(NSError *error))completion;

// FETCHING
+ (instancetype)GET:(NSString *)uid inManagedObjectContext:(NSManagedObjectContext *)context;
+ (instancetype)GET:(NSString *)uid;

+ (NSArray *)allObjects;

+ (NSArray *)allObjectsInManagedObjectContext:(NSManagedObjectContext *)context;

+ (instancetype)managedObjectWithId:(id)uid;

+ (instancetype)managedObjectWithId:(id)uid inManagedObjectContext:(NSManagedObjectContext *)context;

+ (instancetype)managedObjectWithName:(NSString *)name;

+ (instancetype)managedObjectWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

// Batch Updating
+ (NSArray *)batchUpdateAndWaitObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName error:(NSError **)outError;
+ (NSArray *)batchUpdateAndWaitObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName progress:(CGFloat *)outProgress error:(NSError **)error;

+ (void)batchUpdateObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName completion:(void(^)(NSArray *results, NSError *error))completion;
+ (void)batchUpdateObjects:(NSArray *)objects uniqueIdentifierName:(NSString *)uniqueIdentifierName progress:(void(^)(CGFloat progress))progress completion:(void(^)(NSArray *results, NSError *error))completion;

// MAIN MANAGED OBJECT CONTEXT
+ (NSManagedObjectContext *)mainContext;

- (instancetype)mainContextObject;

+ (NSSet *)duplicateManagedObjectsInMainContextForObject:(NSManagedObject *)object;
- (NSString*)loadStringFromDictionary:(NSDictionary*)dict forKey:(NSString *)key;
- (BOOL)loadBoolFromDictionary:(NSDictionary*)dict forKey:(NSString *)key;

@end
