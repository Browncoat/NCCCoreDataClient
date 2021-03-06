//
//  Person+Request.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/31/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import Foundation

extension Person {
    
    struct Initialize {
        static var basePath: String = "https://www.googleapis.com/plus/v1/people/"
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
    
    class func personWithId(id: String, completion:(person: Person?, error: NSError?)->()) {
        self.GET(id, withCompletion: { (results: Array!, error: NSError!) -> Void in
            if (results.count > 0) {
                let person = results[0] as Person
                completion(person: person, error: error)
            } else {
                completion(person: nil, error: error)
            }
        })
    }
}
