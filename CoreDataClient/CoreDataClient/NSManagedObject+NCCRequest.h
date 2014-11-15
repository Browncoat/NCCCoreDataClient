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

#import <CoreData/CoreData.h>

typedef void(^RequestCompletionBlock)(NSArray *results, NSError *error);
typedef void(^CompletionBlock)(NSArray *results, NSError *error);
typedef void(^ProgressBlock)(CGFloat progress);

@interface NSManagedObject (NCCRequest)

/*
@property (nonatomic, strong) NSString *basePath;
@property (nonatomic, strong) NSDictionary *defaultHeaders;
@property (nonatomic, strong) NSString *uniqueIdentifierKey;
*/

+ (void)setBasePath:(NSString *)basePath;
+ (void)setDefaultHeaders:(NSDictionary *)headers;
+ (void)setUniqueIdentifierKey:(NSString *)uniqueIdentifierKey;

// GET
- (void)GETWithCompletion:(RequestCompletionBlock)completionBlock;
+ (void)GETWithCompletion:(RequestCompletionBlock)completionBlock;
+ (void)GET:(NSString *)resource progress:(void(^)(CGFloat progress))progressBlock request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock;
+ (void)GET:(NSString *)resource request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock;
+ (void)GET:(NSString *)resource progress:(void(^)(CGFloat progress))progressBlock withCompletion:(RequestCompletionBlock)completionBlock;
+ (void)GET:(NSString *)resource withCompletion:(RequestCompletionBlock)completionBlock;
- (void)GET:(NSString *)resource progress:(void(^)(CGFloat progress))progressBlock withCompletion:(RequestCompletionBlock)completionBlock;
- (void)GET:(NSString *)resource request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock;
- (void)GET:(NSString *)resource withCompletion:(RequestCompletionBlock)completionBlock;

// POST
- (void)POSTWithCompletion:(RequestCompletionBlock)completionBlock;
+ (void)POST:(NSString *)resource progress:(void(^)(CGFloat progress))progressBlock request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock;
+ (void)POST:(NSString *)resource request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock;
- (void)POST:(NSString *)resource progress:(void(^)(CGFloat progress))progressBlock request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock;
- (void)POST:(NSString *)resource request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock;

- (BOOL)POSTWithError:(NSError **)error;
- (BOOL)POST:(NSString *)resource withError:(NSError **)error;

// PUT
- (void)PUTWithCompletion:(RequestCompletionBlock)completionBlock;
- (void)PUT:(NSString *)resource request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock;

- (BOOL)PUTWithError:(NSError **)error;
- (BOOL)PUT:(NSString *)enresourcetity withError:(NSError **)error;

- (void)saveValuesForKeys:(NSArray *)keys withCompletion:(CompletionBlock)completion;

// DELETE
+ (void)DELETE:(NSString *)resource request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock;
- (void)DELETE:(NSString *)resource withCompletion:(RequestCompletionBlock)completionBlock;
- (void)DELETE:(NSString *)resource request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock;
- (void)DELETEWithCompletion:(RequestCompletionBlock)completionBlock;

- (BOOL)DELETEWithError:(NSError **)error;
- (BOOL)DELETE:(NSString *)resource withError:(NSError **)error;

- (NSDictionary *)dictionaryWithValuesForKeys:(NSArray *)keys;
- (NSDictionary *)dictionaryWithAttributeToKeyPathMappings:(NSDictionary *)keys;

@end
