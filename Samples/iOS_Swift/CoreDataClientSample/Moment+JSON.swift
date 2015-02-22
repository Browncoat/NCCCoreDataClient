//
//  Moment+JSON.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/31/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import Foundation

extension Moment {
    override func updateWithDictionary(dictionary: [NSObject : AnyObject]!) {
        self.uid = dictionary["id"] as? String
        self.kind = dictionary["kind"] as? String
        self.title = dictionary["title"] as? String
    }
}