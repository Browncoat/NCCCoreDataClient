//
//  Moment+Request.m
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 11/4/14.
//  Copyright (c) 2014 Nathaniel Potter. All rights reserved.
//

#import "Moment+Request.h"

@implementation Moment (Request)

+ (void)initialize
{
    [self setBasePath:@"https://www.googleapis.com/plus/v1/people/me/moments/vault/"];
}

- (void)saveWithCompletion:(void(^)(Moment *moment, NSError *error))completion
{
    [self POST:@"" progress:nil request:^(NSMutableURLRequest *request) {
        NSError *error;
        NSData *postBody = [NSJSONSerialization dataWithJSONObject:[self moment] options:0 error:&error];
        [request setData:postBody ofContentType:postBodyContentTypeJSON];
    } withCompletion:^(NSArray *results, NSError *error) {
        completion(results.lastObject, error);
    }];
}

- (NSDictionary *)moment
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];

    NSDictionary *moment = @{@"type":@"http://schema.org/AddAction",
                             @"startDate":dateString,
                             @"object":@{@"id":@"target-id-1",
                                          @"image":@"http://www.google.com/s2/static/images/GoogleyEyes.png",
                                          @"type":@"http://schema.org/AddAction",
                                          @"description":@"The description for the activity",
                                          @"name":@"An example of AddActivity"}
                               };
    NSLog(@"----- %@", moment);
    
    return moment;
                             /*
    var payload = {
        "type":"http:\/\/schemas.google.com\/AddActivity",
        "startDate": "2012-10-31T23:59:59.999Z"
    };
    if (url != undefined){
        payload.target = {
            'url' : 'https://developers.google.com/+/plugins/snippet/examples/thing'
        };
    }else{
        payload.target = {
            "id" : "replacewithuniqueidforaddtarget",
            "image" : "http:\/\/www.google.com\/s2\/static\/images\/GoogleyEyes.png",
            "type" : "http:\/\/schema.org\/CreativeWork",
            "description" : "The description for the activity",
            "name":"An example of AddActivity"
        };
    }
                              */
}

@end
