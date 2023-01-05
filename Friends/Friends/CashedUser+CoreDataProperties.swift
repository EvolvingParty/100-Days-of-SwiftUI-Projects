//
//  CashedUser+CoreDataProperties.swift
//  Friends
//
//  Created by Kurt Lane on 5/1/2023.
//
//

import Foundation
import CoreData


extension CashedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CashedUser> {
        return NSFetchRequest<CashedUser>(entityName: "CashedUser")
    }

    @NSManaged public var about: String?
    @NSManaged public var address: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var registered: String?
    @NSManaged public var tags: String?
    @NSManaged public var friendIDs: String?

}

extension CashedUser : Identifiable {

}
