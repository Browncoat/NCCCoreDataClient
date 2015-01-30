//
//  Comment.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/25/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import Foundation
import CoreData

class Comment: NSManagedObject {

    @NSManaged var createdTime: NSDate
    @NSManaged var id: String
    @NSManaged var text: String
    @NSManaged var from: User

}
