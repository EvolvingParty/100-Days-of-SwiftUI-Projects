//
//  InstafilterApp.swift
//  Instafilter
//
//  Created by Kurt Lane on 5/1/2023.
//

import SwiftUI

@main
struct InstafilterApp: App {
    @State var inputImage = UIImage(named: "Example")!
    var body: some Scene {
        WindowGroup {
            TabView {
                OnChangeView()
                    .tabItem {
                        Label("OnChange", systemImage: "camera.filters")
                    }
                ConfirmationView()
                    .tabItem {
                        Label("Confirmation", systemImage: "square.and.pencil")
                    }
                ImageEffectsView(inputImage: $inputImage)
                    .tabItem {
                        Label("Image Effects", systemImage: "photo.artframe")
                    }
                PHPickerView(inputImage: $inputImage)
                    .tabItem {
                        Label("PHPicker", systemImage: "photo.stack")
                    }
                ContentView()
                    .tabItem {
                        Label("Instafilter", systemImage: "camera.macro")
                    }
            }
        }
    }
}
