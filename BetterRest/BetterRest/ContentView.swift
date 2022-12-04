//
//  ContentView.swift
//  BetterRest
//
//  Created by Kurt Lane on 3/12/2022.
//

import CoreML
import SwiftUI

struct NiceAndLargeFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.largeTitle,design: .rounded).weight(.heavy))
    }
}

extension View {
    func LargeFont() -> some View {
        modifier(NiceAndLargeFont())
    }
}

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
//    @State private var alertTitle = ""
//    @State private var alearMessage = ""
//    @State private var showingAlert = false
    
    //@State private var recommendedBedtime = ""
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var recommendedBedtime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour,.month], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
//            alertTitle = "Bedtime"
//            alearMessage = "Your bedtime shoud be \(sleepTime.formatted(date: .omitted, time: .shortened))"
            return "Your bedtime should be \(sleepTime.formatted(date: .omitted, time: .shortened))"
        } catch {
            //Error
//            alertTitle = "Error"
//            alearMessage = "Something went wrong"
            return "Something went wrong"
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                //VStack(alignment: .leading, spacing: 0) {
                    //Text("When do you want to wake up?")
                        //.font(.headline)
                    DatePicker("Select a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        //.labelsHidden()
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                } header: {
                    Text("When do you want to wake up?")
                }
                Section {
                //VStack(alignment: .leading, spacing: 0) {
                    //Text("Desired hours of sleep?")
                        //.font(.headline)
                    Stepper ("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    //.labelsHidden()
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                } header: {
                    Text("Desired hours of sleep?")
                }
                Section {
                //VStack(alignment: .leading, spacing: 0) {
                    //Text("Daily coffee intake?")
                        //.font(.headline)
                    //Stepper (coffeeAmount == 1 ? "1 cup" : " \(coffeeAmount) cups", value: $coffeeAmount, in: 1...20, step: 1)
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) {
                            Text($0 == 1 ? "1 cup" : "\($0) cups")
                        }
                    }
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                } header: {
                    Text("Daily coffee intake?")
                }
                
                Section {
                    Text(recommendedBedtime)
                        .LargeFont()
                } header: {
                    Text("Recommended bedtime")
                }
            }
            .navigationTitle("BetterRest")
//            .toolbar {
//                Button("Calculate", action: calculateBedtime)
//            }
//            .alert(alertTitle, isPresented: $showingAlert, actions: {
//                Button("OK") {}
//            }, message: {
//                Text(alearMessage)
//            })
            
            //To Remove the calculate button entirely, I added .onAppear & .onChange
//            .onAppear(perform: {calculateBedtime()})
//            .onChange(of: wakeUp, perform: {_ in calculateBedtime()})
//            .onChange(of: sleepAmount, perform: {_ in calculateBedtime()})
//            .onChange(of: coffeeAmount, perform: {_ in calculateBedtime()})
        }
//        VStack {
//            Stepper ("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
//                .labelsHidden()
//            DatePicker("Please enter a time", selection: $wakeUp, in: Date.now...)
//                //.labelsHidden()
//            Text(Date.now, format: .dateTime.hour().minute())
//        }
    }
    
//    func calculateBedtime() {
//        do {
//            let config = MLModelConfiguration()
//            let model = try SleepCalculator(configuration: config)
//            let components = Calendar.current.dateComponents([.hour,.month], from: wakeUp)
//            let hour = (components.hour ?? 0) * 60 * 60
//            let minute = (components.minute ?? 0) * 60
//            let prediction = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
//            let sleepTime = wakeUp - prediction.actualSleep
////            alertTitle = "Bedtime"
////            alearMessage = "Your bedtime shoud be \(sleepTime.formatted(date: .omitted, time: .shortened))"
//            recommendedBedtime = "Your bedtime should be \(sleepTime.formatted(date: .omitted, time: .shortened))"
//        } catch {
//            //Error
////            alertTitle = "Error"
////            alearMessage = "Something went wrong"
//            recommendedBedtime = "Something went wrong"
//        }
//        //showingAlert = true
//    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
