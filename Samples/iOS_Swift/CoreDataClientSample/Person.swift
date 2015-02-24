//
//  Person.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/25/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    @NSManaged var displayName: String?
    @NSManaged var id: String?
    @NSManaged var url: String?

}
