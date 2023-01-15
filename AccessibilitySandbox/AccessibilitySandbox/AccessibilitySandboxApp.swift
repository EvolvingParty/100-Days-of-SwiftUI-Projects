//
//  AccessibilitySandboxApp.swift
//  AccessibilitySandbox
//
//  Created by Kurt L on 15/1/2023.
//

import SwiftUI

@main
struct AccessibilitySandboxApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                AccessabilityLabelsView()
                    .tabItem {
                        Label("Labels", systemImage: "character.cursor.ibeam")
                    }
                ContentView()
                    .tabItem {
                        Label("Menu", systemImage: "list.dash")
                    }
            }
        }
    }
}
