//
//  DataController.swift
//  RememberThings
//
//  Created by Kurt L on 18/1/2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "RememberThingsModel")
    
    init() {
        container.loadPersistentStores { descriptoin, error in
            if let error = error {
                print("Coredata error \(error.localizedDescription)")
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
