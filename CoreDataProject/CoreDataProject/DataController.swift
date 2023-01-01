//
//  DataController.swift
//  Bookworm
//
//  Created by Kurt Lane on 30/12/2022.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CoreDataProject")
    
    init() {
        container.loadPersistentStores { descriptoin, error in
            if let error = error {
                print("Coredata error \(error.localizedDescription)")
                return
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
