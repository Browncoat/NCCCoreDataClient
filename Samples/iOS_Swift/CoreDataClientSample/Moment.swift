//
//  Moment.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/25/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import Foundation
import CoreData

class Moment: NSManagedObject {

    @NSManaged var uid: String?
    @NSManaged var kind: String?
    @NSManaged var startdate: NSDate?
    @NSManaged var title: String?
    @NSManaged var type: String?
    @NSManaged var object: NSManagedObject

}
