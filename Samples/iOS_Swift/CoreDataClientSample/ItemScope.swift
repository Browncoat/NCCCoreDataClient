//
//  ItemScope.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/25/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import Foundation
import CoreData

class ItemScope: NSManagedObject {

    @NSManaged var descriptionString: String
    @NSManaged var id: String
    @NSManaged var imagePath: String
    @NSManaged var name: String
    @NSManaged var type: String

}
