//
//  FlashzillaApp.swift
//  Flashzilla
//
//  Created by Kurt L on 26/1/2023.
//

import SwiftUI

@main
struct FlashzillaApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                PressesView()
                    .tabItem {
                        Label("PressesView", systemImage: "hand.raised.fingers.spread")
                    }
                CompoundTouchesView()
                    .tabItem {
                        Label("CompoundTouches", systemImage: "hand.point.up.braille")
                    }
                VibrationsAndCoreHapticsView()
                    .tabItem {
                        Label("VibrationsCoreHaptics", systemImage: "bell.and.waves.left.and.right")
                    }
                AllowsHitTestingView()
                    .tabItem {
                        Label("VibrationsCoreHaptics", systemImage: "dot.circle.and.hand.point.up.left.fill")
                    }
                TimersView()
                    .tabItem {
                        Label("Timers", systemImage: "timer")
                    }
                ScenePhaseChangeView()
                    .tabItem {
                        Label("Scene Phase", systemImage: "lightbulb.slash")
                    }
                SupportingAccessibility()
                    .tabItem {
                        Label("Supporting Accessibility", systemImage: "figure.roll")
                    }
                ContentView()
                    .tabItem {
                        Label("Flashsilla", systemImage: "mail.stack")
                    }
            }
        }
    }
}
