//
//  RememberThingsApp.swift
//  RememberThings
//
//  Created by Kurt L on 18/1/2023.
//

import SwiftUI

@main
struct RememberThingsApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
