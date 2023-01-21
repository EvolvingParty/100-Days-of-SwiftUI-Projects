//
//  Thing+CoreDataClass.swift
//  RememberThings
//
//  Created by Kurt L on 19/1/2023.
//
//

import Foundation
import CoreData

@objc(Thing)
public class Thing: NSManagedObject {

    static var sampleThing: Thing {
        let childContext = DataController().container.viewContext
        let exampleThing: Thing
        exampleThing = Thing(context: childContext)
        exampleThing.name = "Example thing"
        exampleThing.imageUUID = UUID().uuidString
        exampleThing.dateTime = Date.now
        exampleThing.notes = ""
        return exampleThing
    }
    
}
