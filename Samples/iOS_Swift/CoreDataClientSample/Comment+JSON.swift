//
//  CommentJSON.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/27/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import Foundation

extension Comment {
    override func updateWithDictionary(dictionary: [NSObject : AnyObject]!) {
        self.id = dictionary["id"] as String
        self.text = dictionary["text"] as String
        
        struct DateFormatter {
            static var dateFormatter: NSDateFormatter = {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter
                }()
        }
        
        var dateFormatter: NSDateFormatter {
            get { return DateFormatter.dateFormatter }
        }
        
        if let date = dateFormatter.dateFromString(dictionary["created_at"] as String) {
            self.createdTime = date
        }
        
        let userDict = dictionary["from"] as NSDictionary
        let userId = (dictionary["from"] as NSDictionary)["id"] as NSString
        
        self.from = User.upsertObjectWithDictionary(userDict, uid: userId, inManagedObjectContext: self.managedObjectContext)
    }
}