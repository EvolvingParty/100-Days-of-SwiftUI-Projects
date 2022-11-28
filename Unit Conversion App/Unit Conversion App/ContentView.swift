//
//  ContentView.swift
//  Unit Conversion App
//
//  Created by Kurt Lane on 26/11/2022.
//

import SwiftUI

struct ContentView: View {
    private let timeUnitOptions = ["Seconds", "Minutes", "Hours","Days"]
    @State private var input: Double = 0.0
    @State private var selectedUnit = "Seconds"
    @State private var convertToUnit = "Seconds"
    @FocusState private var inputIsFocused: Bool
    
    var result: Double {
        var initialValueInSeconds = 0.0
        switch selectedUnit {
        case "Seconds": initialValueInSeconds = input
        case "Minutes": initialValueInSeconds = input*60.0
        case "Hours": initialValueInSeconds = input*60.0*60.0
        case "Days": initialValueInSeconds = input*60.0*60.0*24.0
        default: return 0.0
        }
        switch convertToUnit {
        case "Seconds": return initialValueInSeconds
        case "Minutes": return initialValueInSeconds/60.0
        case "Hours": return initialValueInSeconds/60.0/60.0
        case "Days": return initialValueInSeconds/60.0/60.0/24.0
        default: return 0.0
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        TextField("Inout", value: $input, format: .number)
                            .keyboardType(/*@START_MENU_TOKEN@*/.decimalPad/*@END_MENU_TOKEN@*/)
                            .focused($inputIsFocused)
                        Spacer()
                        Picker("", selection: $selectedUnit) {
                            ForEach(timeUnitOptions, id: \.self) {
                                Text("\($0)")
                            }
                        }
                    }
                } header: {
                    Text("Enter a time and unit of measurment")
                }
                Section {
                    Picker("Convert to", selection: $convertToUnit) {
                        ForEach(timeUnitOptions, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
                Section {
                    Text("\(result.formatted()) \(convertToUnit)")
                } header: {
                    Text("Result")
                }
            }.navigationTitle("Time conversion app")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            inputIsFocused = false
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
