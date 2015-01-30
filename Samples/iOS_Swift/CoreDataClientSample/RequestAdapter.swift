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
        println("\(request)")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: NSError?
            if let responseObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
                if let results: NSArray = responseObject["playlist"]?["a"]? as? NSArray {
                    completion(results, error?)
                }
            }
        }
    }
}