// NSMutableURLRequest+NCCCreate.m
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

#import "NSMutableURLRequest+NCCCreate.h"
#import <CommonCrypto/CommonDigest.h>

NSString * const postBodyContentTypeData = @"multipart/form-data; boundary=---------------------------14737809831466499882746641449";
NSString * const postBodyContentTypeJSON = @"application/json";

@implementation NSMutableURLRequest (NCCCreate)

+ (NSMutableURLRequest *)requestWithUrlString:(NSString *)urlString, ...
{
    NSMutableURLRequest *request;
    NSData *data;
    NSString *contentType;
    
    id argumentObject;
    va_list argumentList;
    if (urlString) { // The first argument isn't part of the varargs list,
        request = [[self class] requestWithURL:[NSURL URLWithString:urlString]];
        
        va_start(argumentList, urlString); // Start scanning for arguments after urlString.
        while ((argumentObject = va_arg(argumentList, id))) { // As many times as we can get an argument of type "id"
            if ([argumentObject isKindOfClass:[NSDictionary class]]) {
                [request setHeaders:argumentObject];
            } else if ([argumentObject isKindOfClass:[NSString class]]) {
                if ([argumentObject rangeOfString:@"?"].location != NSNotFound) {
                    [request setParams:argumentObject];
                } else {
                    contentType = argumentObject;
                }
                [request setData:data ofContentType:argumentObject];
            } else if ([argumentObject isKindOfClass:[NSData class]]) {
                data = (NSData *)argumentObject;
            }
        }
        
        if (data.length && contentType) {
            [request setData:data ofContentType:contentType];
        }
        
        va_end(argumentList);
    }
    
    return request;
}

#pragma mark - Set URL Components

- (void)addHeaders:(NSDictionary *)headers
{
    if (headers) {
        for (NSString *key in headers) {
            [self addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
}

- (void)setHeaders:(NSDictionary *)headers
{
    if (headers) {
        for (NSString *key in headers) {
            [self setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
}

- (void)setParams:(NSString *)params
{
    if (params) {
        NSString *urlString = [[self.URL absoluteString] stringByAppendingString:params];
        self.URL = [NSURL URLWithString:urlString];
    }
}

- (void)setData:(NSData *)data ofContentType:(NSString *)postBodyContentType
{
    if (data) {
        [self setValue:postBodyContentType forHTTPHeaderField:@"Content-Type"];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
        [self setValue:postLength forHTTPHeaderField:@"Content-Length"];
        self.HTTPBody = data;
    }
}

#pragma mark - Post Body

+ (NSData *)postBodyFromString:(NSString *)string
{
    return (NSMutableData *)[string dataUsingEncoding:NSASCIIStringEncoding];
}

+ (NSData *)postBodyFromDictionary:(NSDictionary *)dictionary
{
    NSError *error = nil;
    NSData *body = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (!error) {
        return body;
    }
    
    return nil;
}

+ (NSString *)boundary
{
    NSString *boundaryIdentifierString = @"boundary=";
    NSRange range = [postBodyContentTypeData rangeOfString:boundaryIdentifierString];
    return [postBodyContentTypeData substringFromIndex:range.location + range.length];
}

@end
