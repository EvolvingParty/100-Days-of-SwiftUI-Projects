//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Kurt Lane on 30/12/2022.
//

import SwiftUI

@main
struct BookwormApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
//            CoreDataView()
//                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
