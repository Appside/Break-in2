//
//  Person+CoreDataProperties.swift
//  
//
//  Created by Jonathan Crawford on 20/12/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var declinedPermissions: AnyObject?
    @NSManaged var permissions: AnyObject?
    @NSManaged var token: String?
    @NSManaged var appID: String?
    @NSManaged var userID: String?
    @NSManaged var expirationDate: Date?
    @NSManaged var refreshDate: Date?

}
