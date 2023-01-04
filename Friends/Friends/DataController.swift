//
//  DataController.swift
//  Bookworm
//
//  Created by Kurt Lane on 30/12/2022.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FriendFaceDataModel")
    
    init() {
        container.loadPersistentStores { descriptoin, error in
            if let error = error {
                print("Coredata error \(error.localizedDescription)")
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
