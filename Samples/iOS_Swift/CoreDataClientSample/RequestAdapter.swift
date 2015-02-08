//
//  RequestAdapter.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/25/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    class func makeRequest(request: NSMutableURLRequest!, progress: ((CGFloat) -> Void)!, completion: (([AnyObject]!, NSError!) -> Void)!) {
        if let token = NSUserDefaults.standardUserDefaults().stringForKey(Authentication.clientAuthTokenKey) {
            let headers = ["Authorization":"Bearer \(token)"]
            request.setHeaders(headers)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                var error: NSError?
                if let responseObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
                    completion([responseObject], error?)
                }
            }
        }
    }
}