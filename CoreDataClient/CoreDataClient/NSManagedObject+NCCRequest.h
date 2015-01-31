// NSManagedObject+NCCRequest.h
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

typedef void(^ProgressBlock)(CGFloat progress);
typedef void(^RequestModifyBlock)(NSMutableURLRequest *request);
typedef void(^RequestCompletionBlock)(NSArray *results, NSError *error);
typedef void(^CompletionBlock)(NSArray *results, NSError *error);

@interface NSManagedObject (NCCRequest)

+ (void)setBasePath:(NSString *)basePath;
+ (NSString *)basePath;

+ (void)setResponseObjectUidKey:(NSString *)uid;
+ (NSString *)responseObjectUidKey;

+ (void)setManagedObjectUidKey:(NSString *)uid;
+ (NSString *)managedObjectUidKey;

// GET
+ (void)GET:(NSString *)resource progress:(ProgressBlock)progressBlock request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock;
+ (void)GET:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock;
+ (void)GET:(NSString *)resource progress:(ProgressBlock)progressBlock withCompletion:(CompletionBlock)completionBlock;
+ (void)GET:(NSString *)resource withCompletion:(CompletionBlock)completionBlock;
+ (void)GETWithCompletion:(CompletionBlock)completionBlock;

- (void)GET:(NSString *)resource progress:(ProgressBlock)progressBlock withCompletion:(CompletionBlock)completionBlock;
- (void)GET:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock;
- (void)GET:(NSString *)resource withCompletion:(CompletionBlock)completionBlock;
- (void)GETWithCompletion:(CompletionBlock)completionBlock;

// POST
+ (void)POST:(NSString *)resource progress:(ProgressBlock)progressBlock request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock;
+ (void)POST:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock;

- (void)POST:(NSString *)resource progress:(ProgressBlock)progressBlock request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock;
- (void)POST:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock;

// PUT
- (void)PUT:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock;

// DELETE
+ (void)DELETE:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock;
- (void)DELETE:(NSString *)resource withCompletion:(CompletionBlock)completionBlock;
- (void)DELETE:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock;
- (void)DELETEWithCompletion:(CompletionBlock)completionBlock;

// KeyPath Mapping
- (NSDictionary *)dictionaryWithValuesForKeys:(NSArray *)keys;
- (NSDictionary *)dictionaryWithAttributeToKeyPathMappings:(NSDictionary *)keys;

// Overrides
//- (void)saveValuesForKeys:(NSArray *)keys withCompletion:(CompletionBlock)completion;

@end

@interface NSManagedObject (RequestAdapter)

- (void)makeRequest:(NSMutableURLRequest *)request progress:(ProgressBlock)progress completion:(RequestCompletionBlock)completion;
+ (void)makeRequest:(NSMutableURLRequest *)request progress:(ProgressBlock)progress completion:(RequestCompletionBlock)completion;

@end
