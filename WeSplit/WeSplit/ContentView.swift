//
//  ContentView.swift
//  WeSplit
//
//  Created by Kurt Lane on 23/11/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var noOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    let tipPercentages = [10,15,20,25,0]
    
    var totalPerPerson: Double {
        let numberOfPeep = Double(noOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / numberOfPeep
        return amountPerPerson
    }
    
    var totalAmount: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        return grandTotal
    }
    
    func currencyFormat() -> FloatingPointFormatStyle<Double>.Currency {
        .currency(code: Locale.current.currencyCode ?? "USD")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(/*@START_MENU_TOKEN@*/.decimalPad/*@END_MENU_TOKEN@*/)
                        .focused($amountIsFocused)
                    if #available(iOS 16.0, *) {
                        Picker("Number of people", selection: $noOfPeople) {
                            ForEach(2..<100) {
                                Text("\($0) people")
                            }
                        }.pickerStyle(.navigationLink)
                    } else {
                        Picker("Number of people", selection: $noOfPeople) {
                            ForEach(2..<100) {
                                Text("\($0) people")
                            }
                        }
                    }
                }
                
                Section {
//                    Picker("Tip percenatge", selection: $tipPercentage) {
//                        ForEach(tipPercentages, id: \.self) {
//                            Text($0, format: .percent)
//                        }
//                    }.pickerStyle(.segmented)
                    if #available(iOS 16.0, *) {
                        Picker("Tip percenatge", selection: $tipPercentage) {
                            ForEach(0..<101) {
                                Text($0, format: .percent)
                            }
                        }.pickerStyle(.navigationLink)
                    } else {
                        Picker("Tip percenatge", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text($0, format: .percent)
                            }
                        }.pickerStyle(.segmented)
                    }
                } header: {
                    Text("Tip percentage")
                }
                
                Section {
                    Text(totalAmount, format: currencyFormat())
                } header: {
                    Text("Total Amount")
                }
                
                Section {
                    Text(totalPerPerson, format: currencyFormat())
                } header: {
                    Text("Amount per person")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
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
