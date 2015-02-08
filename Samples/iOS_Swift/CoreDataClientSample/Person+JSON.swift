//
//  Person+JSON.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/31/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import Foundation

extension Person {
   
    override func updateWithDictionary(dictionary: [NSObject : AnyObject]!) {
        self.id = dictionary["id"] as? String;
        self.displayName = dictionary["displayName"] as? String;
        self.url = dictionary["url"] as? String;
    }
}