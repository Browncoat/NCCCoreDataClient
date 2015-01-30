//
//  User.swift
//  CoreDataClientSample
//
//  Created by Nathaniel Potter on 1/25/15.
//  Copyright (c) 2015 Nathaniel Potter. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var bio: String
    @NSManaged var fullName: String
    @NSManaged var id: String
    @NSManaged var profilePicturePath: String
    @NSManaged var userName: String
    @NSManaged var website: String
    @NSManaged var comments: NSSet

}
