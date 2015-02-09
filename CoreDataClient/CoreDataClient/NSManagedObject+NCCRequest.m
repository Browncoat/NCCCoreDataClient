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
#import "NCCCoreDataClient.h"

@implementation NSManagedObject (NCCRequest)

+ (void)setBasePath:(NSString *)newBasePath {
    BOOL hasTrailingSlash = [newBasePath characterAtIndex:newBasePath.length - 1] == '/';
    if (!hasTrailingSlash) {
        NSLog(@"WARNING: %@ does not contain a trailing '/'", newBasePath);
    }
    objc_setAssociatedObject(self, @selector(basePath), newBasePath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSString *)basePath {
    return objc_getAssociatedObject(self, @selector(basePath));
}

+ (void)setDefaultHeaders:(NSDictionary *)newDefaultHeaders {
    objc_setAssociatedObject(self, @selector(defaultHeaders), newDefaultHeaders, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSDictionary *)defaultHeaders {
    return objc_getAssociatedObject(self, @selector(defaultHeaders));
}

+ (void)setResponseObjectUidKey:(NSString *)uidKey
{
    objc_setAssociatedObject(self, @selector(responseObjectUidKey), uidKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSString *)responseObjectUidKey
{
    NSString *key = objc_getAssociatedObject(self, @selector(responseObjectUidKey));
    if (key) {
        return key;
    } else {
        return @"id";
    }
}

+ (void)setManagedObjectUidKey:(NSString *)uidKey
{
    objc_setAssociatedObject(self, @selector(managedObjectUidKey), uidKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSString *)managedObjectUidKey
{
    NSString *key = objc_getAssociatedObject(self, @selector(managedObjectUidKey));
    if (key) {
        return key;
    } else {
        return @"id";
    }
}

+ (void)checkClassNameIncludedInRequestUrl:(NSURL *)requestURL
{
    BOOL success = [requestURL.absoluteString rangeOfString:NSStringFromClass([self class]) options:NSCaseInsensitiveSearch].location != NSNotFound;
    
    if (!success) {
        NSLog(@"WARNING: %@ does not contain name of class %@, this may be the incorrect class to process this request", requestURL.absoluteString, NSStringFromClass([self class]));
    }
}

#pragma mark - GET

+ (void)GET:(NSString *)resource progress:(ProgressBlock)progressBlock request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self basePath]]];
    if (resource.length) {
        request.URL = [NSURL URLWithString:resource relativeToURL:request.URL];
    }
    request.HTTPMethod = @"GET";
    
    if (requestModifyBlock) {
        requestModifyBlock(request);
    }
    
    [[self class] checkClassNameIncludedInRequestUrl:request.URL];
    
    RequestCompletionBlock requestCompletionBlock = ^(NSArray *results, NSError *error) {
        if (results) {
            [[self class] batchUpdateObjects:results uniqueIdentifierName:[self responseObjectUidKey] progress:^(CGFloat progress) {
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
                completionBlock(@[], error);
            }
        }
    };
    
    /*
    NSMethodSignature * mySignature = [NSManagedObject instanceMethodSignatureForSelector:@selector(makeRequest:progress:completion:)];
    NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:mySignature];
    [myInvocation setTarget:[self class]];
    [myInvocation setSelector:@selector(makeRequest:progress:completion:)];
    [myInvocation setArgument:&request atIndex:2];
    [myInvocation setArgument:&progressBlock atIndex:3];
    [myInvocation setArgument:&requestCompletionBlock atIndex:4];
    [myInvocation invoke];
    */
    [self makeRequest:request progress:(ProgressBlock)progressBlock completion:requestCompletionBlock];
}

+ (void)GET:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock
{
    [self GET:resource progress:nil request:requestModifyBlock withCompletion:completionBlock];
}

+ (void)GET:(NSString *)resource progress:(ProgressBlock)progressBlock withCompletion:(CompletionBlock)completionBlock
{
    [self GET:resource progress:progressBlock request:nil withCompletion:completionBlock];
}

+ (void)GET:(NSString *)resource withCompletion:(CompletionBlock)completionBlock
{
   [self GET:resource progress:nil request:nil withCompletion:completionBlock];
}

+ (void)GETWithCompletion:(CompletionBlock)completionBlock
{
    [self GET:nil progress:nil request:nil withCompletion:completionBlock];
}

- (void)GET:(NSString *)resource progress:(ProgressBlock)progressBlock withCompletion:(CompletionBlock)completionBlock
{
    [[self class] GET:resource progress:progressBlock request:nil withCompletion:completionBlock];
}

- (void)GET:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock
{
    [[self class] GET:resource progress:nil request:requestModifyBlock withCompletion:completionBlock];
}

- (void)GET:(NSString *)resource withCompletion:(CompletionBlock)completionBlock
{
    [[self class] GET:resource progress:nil request:nil withCompletion:completionBlock];
}

- (void)GETWithCompletion:(CompletionBlock)completionBlock
{
    [[self class] GETWithCompletion:completionBlock];
}

#pragma mark - POST

+ (void)POST:(NSString *)resource progress:(ProgressBlock)progressBlock request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self basePath]]];
    if (resource.length) {
        request.URL = [NSURL URLWithString:resource relativeToURL:request.URL];
    }
    request.HTTPMethod = @"POST";
    
    if (requestModifyBlock) {
        requestModifyBlock(request);
    }
    
    [[self class] checkClassNameIncludedInRequestUrl:request.URL];
    
    RequestCompletionBlock requestCompletionBlock = ^(NSArray *results, NSError *error) {
        if (results) {
            [[self class] batchUpdateObjects:results uniqueIdentifierName:[self responseObjectUidKey] progress:^(CGFloat progress) {
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
                completionBlock(@[], error);
            }
        }
    };
    
    /*
    NSMethodSignature * mySignature = [NSManagedObject instanceMethodSignatureForSelector:@selector(makeRequest:progress:completion:)];
    NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:mySignature];
    [myInvocation setTarget:[self class]];
    [myInvocation setSelector:@selector(makeRequest:progress:completion:)];
    [myInvocation setArgument:&request atIndex:2];
    [myInvocation setArgument:&progressBlock atIndex:3];
    [myInvocation setArgument:&requestCompletionBlock atIndex:4];
    [myInvocation invoke];
     */
    [self makeRequest:request progress:(ProgressBlock)progressBlock completion:requestCompletionBlock];
}

+ (void)POST:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock
{
    [self POST:resource progress:nil request:requestModifyBlock withCompletion:completionBlock];
}

- (void)POST:(NSString *)resource progress:(ProgressBlock)progressBlock request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock
{
    [[self class] POST:resource progress:progressBlock request:requestModifyBlock withCompletion:completionBlock];
}

- (void)POST:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock
{
    [self POST:resource progress:nil request:requestModifyBlock withCompletion:completionBlock];
}

#pragma mark - PUT

- (void)PUT:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[self class] basePath]]];
    if (resource.length) {
        request.URL = [NSURL URLWithString:resource relativeToURL:request.URL];
    }
    request.HTTPMethod = @"PUT";
    
    if (requestModifyBlock) {
        requestModifyBlock(request);
    }
    
    [[self class] checkClassNameIncludedInRequestUrl:request.URL];
    
    /*
    NSMethodSignature * mySignature = [NSManagedObject instanceMethodSignatureForSelector:@selector(makeRequest:progress:completion:)];
    NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:mySignature];
    [myInvocation setTarget:[self class]];
    [myInvocation setSelector:@selector(makeRequest:progress:completion:)];
    [myInvocation setArgument:&request atIndex:2];
    [myInvocation setArgument:nil atIndex:3];
    [myInvocation setArgument:&completionBlock atIndex:4];
    [myInvocation invoke];
    */
    
    [self makeRequest:request progress:nil completion:completionBlock];
}

#pragma mark - DELETE

+ (void)DELETE:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[self class] basePath]]];
    if (resource.length) {
        request.URL = [NSURL URLWithString:resource relativeToURL:request.URL];
    }
    request.HTTPMethod = @"DELETE";
    
    if (requestModifyBlock) {
        requestModifyBlock(request);
    }
    
    [[self class] checkClassNameIncludedInRequestUrl:request.URL];
    
    /*
    NSMethodSignature * mySignature = [NSManagedObject instanceMethodSignatureForSelector:@selector(makeRequest:progress:completion:)];
    NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:mySignature];
    [myInvocation setTarget:[self class]];
    [myInvocation setSelector:@selector(makeRequest:progress:completion:)];
    [myInvocation setArgument:&request atIndex:2];
    [myInvocation setArgument:nil atIndex:3];
    [myInvocation setArgument:&completionBlock atIndex:4];
    [myInvocation invoke];
     */
    [self makeRequest:request progress:nil completion:completionBlock];
}

- (void)DELETE:(NSString *)resource request:(RequestModifyBlock)requestModifyBlock withCompletion:(CompletionBlock)completionBlock
{
    [[self class] DELETE:resource request:requestModifyBlock withCompletion:completionBlock];
}

- (void)DELETE:(NSString *)resource withCompletion:(CompletionBlock)completionBlock
{
    [self DELETE:resource request:nil withCompletion:completionBlock];
}

- (void)DELETEWithCompletion:(CompletionBlock)completionBlock
{
    [self DELETE:nil request:nil withCompletion:completionBlock];
}

/*
#pragma mark - Override in RequestAdapter Category


+ (void)makeRequest:(NSMutableURLRequest *)request progress:(void(^)(CGFloat progress))progressBlock withCompletion:(void(^)(id results, NSError *error))completion
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass or category", NSStringFromSelector(_cmd)];
}

- (void)makeRequest:(NSMutableURLRequest *)request progress:(void(^)(CGFloat progress))progressBlock withCompletion:(void(^)(id results, NSError *error))completion
{
    [[self class] makeRequest:request progress:progressBlock withCompletion:completion];
}
*/

#pragma mark - Dictionary Mapping

- (NSDictionary *)dictionaryWithValuesForKeys:(NSArray *)keys
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        [dictionary setValue:[self valueForKey:key] forKey:key];
    }
    
    return dictionary;
}

- (NSDictionary *)dictionaryWithAttributeToKeyPathMappings:(NSDictionary *)keyMappings
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [keyMappings enumerateKeysAndObjectsUsingBlock:^(id key, id keyMapping, BOOL *stop) {
        [dictionary setValue:[self valueForKeyPath:keyMapping] forKey:key];
    }];
    
    return dictionary;
}

- (void)saveValuesForKeys:(NSArray *)keys withCompletion:(CompletionBlock)completion
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
