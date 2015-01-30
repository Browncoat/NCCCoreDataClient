//
//  Comment+Request.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/30/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import Foundation

extension Comment {
    struct Initialize {
        static var basePath: String = "https://api.instagram.com/v1/media/"
        static var managedObjectUidKey: String = "id"
        static var responseObjectUidKey: String = "id"
    }
    
    class var basePath: String {
        return Initialize.basePath
    }
    
    class var managedObjectUidKey: String {
        return Initialize.managedObjectUidKey
    }
    
    class var responseObjectUidKey: String {
        return Initialize.responseObjectUidKey
    }
    
    func POSTCommentToMedia(media: Media completion:(results: NSArray?, error: NSError?)->()) {
        if let token = NSUserDefaults.standardUserDefaults().stringForKey("access_token") {
            self.POST(<#resource: String!#>, request: { (<#NSMutableURLRequest!#>) -> Void in
                <#code#>
            }, withCompletion: { (<#[AnyObject]!#>, <#NSError!#>) -> Void in
                <#code#>
            })
        }
    }
    
    class func getStuff() {
        
        self.GET("", request: { (request: NSMutableURLRequest!) -> Void in
            //
            }) { (objects: [AnyObject]!, error: NSError!) -> Void in
                //
        }
    }
}

/*
+ (void)initialize
{
[self setBasePath:@"https://api.instagram.com/v1/media/"];
}

- (void)POSTCommentToMedia:(Media *)media withCompletion:(void(^)(NSArray *results, NSError *error))completion
{
NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"];

[self POST:[NSString stringWithFormat:@"%@/%@", media.id, @"comments"] request:^(NSMutableURLRequest *request) {
NSData *formData = [[NSString stringWithFormat:@"access_token=%@&text=%@", token, @"Hellllloooooo"] dataUsingEncoding:NSUTF8StringEncoding];
[request setData:formData ofContentType:postBodyContentTypeData];
} withCompletion:^(id results, NSError *error) {
completion(results, error);
}];
}
*/