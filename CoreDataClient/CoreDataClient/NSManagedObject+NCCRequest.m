// NSManagedObject+NCCRequest.m
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

#import <objc/runtime.h>
#import "NSManagedObject+NCCRequest.h"
#import "NSMutableURLRequest+NCCCreate.h"

static NSString *_basePath = nil;
static NSDictionary *_defaultHeaders = nil;
static NSString *_uniqueIdentifierKey = nil;

@implementation NSManagedObject (NCCRequest)

+ (void)setBasePath:(NSString *)basePath
{
    //NSManagedObject+NCCRequest basePath should only be set once, any other url updates should be made on each request object using setURL: or URLWithString:relativeToURL:
    if (!_basePath) {
        _basePath = basePath;
    }
}

+ (NSString *)basePath
{
    return _basePath;
}

+ (void)setDefaultHeaders:(NSDictionary *)defaultHeaders
{
    //NSManagedObject+NCCRequest defaultHeaders should only be set once, any other header updates should be made on each request object using setHeaders or setValue:forHTTPHeaderField:
    if (!_defaultHeaders) {
        _defaultHeaders = defaultHeaders;
    }
}

+ (NSDictionary *)defaultHeaders
{
    return _defaultHeaders;
}

+ (void)setUniqueIdentifierKey:(NSString *)uniqueIdentifierKey
{
    _uniqueIdentifierKey = uniqueIdentifierKey;
}

+ (NSString *)uniqueIdentifierKey
{
    return _uniqueIdentifierKey;
}

+ (void)checkClassNameIncludedInRequestUrl:(NSURL *)requestURL
{
    BOOL success = [requestURL.absoluteString rangeOfString:NSStringFromClass([self class]) options:NSCaseInsensitiveSearch].location != NSNotFound;
    
    if (!success) {
        NSLog(@"WARNING: %@ does not contain name of class %@, this may be the incorrect class to process this request", requestURL.absoluteString, NSStringFromClass([self class]));
    }
}

#pragma mark - NSMutableURLRequest

- (void)GETWithCompletion:(RequestCompletionBlock)completionBlock
{
    
    
}

#pragma mark - GET

+ (void)GET:(NSString *)resource progress:(void(^)(CGFloat progress))progressBlock request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_basePath]];
    if (resource.length) {
        request.URL = [NSURL URLWithString:resource relativeToURL:request.URL];
    }
    request.HTTPMethod = @"GET";
    [request setHeaders:_defaultHeaders];
    
    if (requestBlock) {
        requestBlock(request);
    }
    
    [[self class] checkClassNameIncludedInRequestUrl:request.URL];
    
    [self makeRequest:request progress:(void(^)(CGFloat progress))progressBlock withCompletion:^(id responseObject, NSError *error) {
        if (responseObject) {
            if (![responseObject isKindOfClass:[NSArray class]]) {
                responseObject = @[responseObject];
            }
            if (!_uniqueIdentifierKey) {
                _uniqueIdentifierKey = @"id";
            }
            [[self class] batchUpdateObjects:responseObject uniqueIdentifierName:_uniqueIdentifierKey progress:^(CGFloat progress) {
                if (progressBlock) {
                    progressBlock(progress);
                }
            } completion:^(NSArray *results, NSError *error) {
                if (completionBlock) {
                    completionBlock(results, error);
                }
            }];
        } else {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

+ (void)GET:(NSString *)resource request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock
{
    [self GET:resource progress:nil request:requestBlock withCompletion:completionBlock];
}

+ (void)GET:(NSString *)resource progress:(void(^)(CGFloat progress))progressBlock withCompletion:(RequestCompletionBlock)completionBlock
{
    [self GET:resource progress:progressBlock request:nil withCompletion:completionBlock];
}

+ (void)GET:(NSString *)resource withCompletion:(RequestCompletionBlock)completionBlock
{
   [self GET:resource progress:nil request:nil withCompletion:completionBlock];
}

- (void)GET:(NSString *)resource progress:(void(^)(CGFloat progress))progressBlock withCompletion:(RequestCompletionBlock)completionBlock
{
    [[self class] GET:resource progress:progressBlock request:nil withCompletion:completionBlock];
}

- (void)GET:(NSString *)resource request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock
{
    [[self class] GET:resource progress:nil request:requestBlock withCompletion:completionBlock];
}

- (void)GET:(NSString *)resource withCompletion:(RequestCompletionBlock)completionBlock
{
    [[self class] GET:resource progress:nil request:nil withCompletion:completionBlock];
}

#pragma mark - POST

+ (void)POST:(NSString *)resource progress:(void(^)(CGFloat progress))progressBlock request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_basePath]];
    if (resource.length) {
        request.URL = [NSURL URLWithString:resource relativeToURL:request.URL];
    }
    request.HTTPMethod = @"POST";
    [request setHeaders:_defaultHeaders];
    
    if (requestBlock) {
        requestBlock(request);
    }
    
    [[self class] checkClassNameIncludedInRequestUrl:request.URL];
    
    [self makeRequest:request progress:(void(^)(CGFloat progress))progressBlock withCompletion:^(id responseObject, NSError *error) {
        if (responseObject) {
            if (![responseObject isKindOfClass:[NSArray class]]) {
                responseObject = @[responseObject];
            }
            if (!_uniqueIdentifierKey) {
                _uniqueIdentifierKey = @"id";
            }
            [[self class] batchUpdateObjects:responseObject uniqueIdentifierName:_uniqueIdentifierKey progress:^(CGFloat progress) {
                if (progressBlock) {
                    progressBlock(progress);
                }
            } completion:^(NSArray *results, NSError *error) {
                if (completionBlock) {
                    completionBlock(results, error);
                }
            }];
        } else {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

+ (void)POST:(NSString *)resource request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock
{
    [self POST:resource progress:nil request:requestBlock withCompletion:completionBlock];
}

- (void)POST:(NSString *)resource progress:(void(^)(CGFloat progress))progressBlock request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock
{
    [[self class] POST:resource progress:progressBlock request:requestBlock withCompletion:completionBlock];
}

- (void)POST:(NSString *)resource request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock
{
    [self POST:resource progress:nil request:requestBlock withCompletion:completionBlock];
}

#pragma mark - PUT

- (void)PUT:(NSString *)resource request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_basePath]];
    if (resource.length) {
        request.URL = [NSURL URLWithString:resource relativeToURL:request.URL];
    }
    request.HTTPMethod = @"PUT";
    [request setHeaders:_defaultHeaders];
    
    if (requestBlock) {
        requestBlock(request);
    }
    
    [[self class] checkClassNameIncludedInRequestUrl:request.URL];
    
    [self makeRequest:request progress:nil withCompletion:completionBlock];
}

#pragma mark - DELETE

- (void)DELETE:(NSString *)resource request:(void(^)(NSMutableURLRequest *request))requestBlock withCompletion:(RequestCompletionBlock)completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_basePath]];
    if (resource.length) {
        request.URL = [NSURL URLWithString:resource relativeToURL:request.URL];
    }
    request.HTTPMethod = @"DELETE";
    [request setHeaders:_defaultHeaders];
    
    if (requestBlock) {
        requestBlock(request);
    }
    
    [[self class] checkClassNameIncludedInRequestUrl:request.URL];
    
    [self makeRequest:request progress:nil withCompletion:completionBlock];
}

#pragma mark - Override in RequestAdapter Category

+ (void)makeRequest:(NSURLRequest *)request progress:(void(^)(CGFloat progress))progressBlock withCompletion:(void(^)(id results, NSError *error))completion
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)makeRequest:(NSURLRequest *)request progress:(void(^)(CGFloat progress))progressBlock withCompletion:(void(^)(id results, NSError *error))completion
{
    [[self class] makeRequest:request progress:progressBlock withCompletion:completion];
}

#pragma mark - Dictionary Mapping

- (NSDictionary *)dictionaryForKeys:(NSArray *)keys
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        [dictionary setValue:[self valueForKey:key] forKey:key];
    }
    
    return dictionary;
}

- (NSDictionary *)dictionaryForKeyPathMappings:(NSDictionary *)keyMappings
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [keyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id keyMapping, BOOL *stop) {
        [dictionary setValue:[self valueForKeyPath:key] forKey:keyMapping];
    }];
    
    return dictionary;
}

- (void)saveValuesForKeys:(NSArray *)keys withCompletion:(CompletionBlock)completion
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
