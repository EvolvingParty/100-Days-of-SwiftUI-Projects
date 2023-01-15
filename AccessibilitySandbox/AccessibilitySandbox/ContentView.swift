//
//  ContentView.swift
//  AccessibilitySandbox
//
//  Created by Kurt L on 15/1/2023.
//

import SwiftUI

struct AccessabilityLabelsView: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]
    let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks"
    ]
    @State private var selectedPicture = Int.random(in: 0...3)
    var body: some View {
        Image(pictures[selectedPicture])
            .resizable()
            .scaledToFit()
            .onTapGesture {
                selectedPicture = Int.random(in: 0...3)
            }
            .accessibilityLabel (labels [selectedPicture])
    }
}

struct ContentView: View {
    @State private var value = 1
    var body: some View {
        VStack {
            Text("Value: \(value)")
            Button("Increment") {
                value += 1
            }
            Button("Decrement") {
                value -= 1
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Value")
        .accessibilityValue(String(value))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: value += 1
            case .decrement: value -= 1
            default: print ("Not handled" )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AccessabilityLabelsView()
            .previewDisplayName("Accessability Labals View")
        ContentView()
    }
}
