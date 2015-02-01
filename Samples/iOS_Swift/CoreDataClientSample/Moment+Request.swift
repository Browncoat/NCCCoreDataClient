//
//  Moment+Request.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/31/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import Foundation

extension Moment {
    
    struct Initialize {
        static var basePath: String = "https://www.googleapis.com/plus/v1/people/me/moments/"
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
    
    func saveMomentWithCompletion(completion: (results: [AnyObject]?, error: NSError?)->()) {
        
        self.POST("vault", request: { (request: NSMutableURLRequest!) -> Void in
            request.setJSON(self.momentDictionary())
        }) { (results: Array!, error: NSError!) -> Void in
            completion(results: results, error: error)
        }
    }
    
    func momentDictionary() -> [NSObject : AnyObject] {
        
        struct DateFormatter {
            static var dateFormatter: NSDateFormatter = {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                return dateFormatter
                }()
        }
        
        var dateFormatter: NSDateFormatter {
            get { return DateFormatter.dateFormatter }
        }
        
        let dateString = dateFormatter.stringFromDate(NSDate())
        
        let moment: Dictionary = [  "type":"http://schema.org/AddAction",
                                    "startDate":dateString,
                                    "object":[  "id":"target-id-1",
                                                "image":"http://www.google.com/s2/static/images/GoogleyEyes.png",
                                                "type":"http://schema.org/AddAction",
                                                "description":"The description for the activity",
                                                "name":"An example of AddActivity"
                                            ]
                                ]
        
        println("\(moment)")
        
        return moment;
    }
}
