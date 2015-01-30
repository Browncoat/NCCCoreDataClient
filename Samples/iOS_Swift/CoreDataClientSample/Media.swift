//
//  Media.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/25/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import Foundation
import CoreData

class Media: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var link: String
    @NSManaged var type: String

}
