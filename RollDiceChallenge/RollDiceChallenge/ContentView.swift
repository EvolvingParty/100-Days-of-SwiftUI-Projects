//
//  ContentView.swift
//  RollDiceChallenge
//
//  Created by Kurt L on 7/2/2023.
//

import SwiftUI

struct ContentView: View {
    
    private let numberOfDiceToRoll = [1,2,3,4,5,6]
    @State private var numberOfDiceSelected = 1
    
    private let numberOfSidesOfDiceBeingRolled = [4,6,8,10,12,20,100]
    @State private var numberOfSidesSelected = 4
    
    @State private var diceArray = ["?","?","?","?","?","?"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("Number of dice:")
                        .font(.headline)
                    Picker("Number Of Dice", selection: $numberOfDiceSelected) {
                        ForEach(numberOfDiceToRoll, id: \.self) { num in
                            Text("\(num)")
                        }
                    }
                    
                    //.pickerStyle(.wheel)
                    //.frame(width: 100, height: 95)
                    //.clipShape(Capsule())
                }
                HStack {
                    Text("Number of sides:")
                        .font(.headline)
                    Picker("Number Of Dice", selection: $numberOfSidesSelected) {
                        ForEach(numberOfSidesOfDiceBeingRolled, id: \.self) { num in
                            Text("\(num)")
                        }
                    }
                    //.pickerStyle(.wheel)
                    //.frame(width: 100, height: 95)
                    //.clipShape(Capsule())
                }
                .padding(.bottom, 30)

                ZStack {
                    Color.green.opacity(0.3)
                    HStack {
                        VStack {
                            Text(diceArray[0])
                                .font(.system(size: 200, design: .rounded).weight(.semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                            if numberOfDiceSelected > 1 {
                                Text(diceArray[1])
                                    .font(.system(size: 200, design: .rounded).weight(.semibold))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
                        }
                        .padding(.horizontal)
                        VStack {
                            if numberOfDiceSelected > 2 {
                                Text(diceArray[2])
                                    .font(.system(size: 200, design: .rounded).weight(.semibold))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
                            if numberOfDiceSelected > 3 {
                                Text(diceArray[3])
                                    .font(.system(size: 200, design: .rounded).weight(.semibold))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
                        }
                        VStack {
                            if numberOfDiceSelected > 4 {
                                Text(diceArray[4])
                                    .font(.system(size: 200, design: .rounded).weight(.semibold))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
                            if numberOfDiceSelected > 5 {
                                Text(diceArray[5])
                                    .font(.system(size: 200, design: .rounded).weight(.semibold))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
                        }
                    }
                }
                
                Button {
                    performRoll()
                } label: {
                    Text("ROLL")
                        .font(.system(.title, design: .rounded).weight(.bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 50)
                        .padding(10)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .padding(.top, 30)
                        
                }
                
            }
            .navigationTitle("Roll Dice")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func performRoll() {
        for (index,_) in diceArray.enumerated() {
            diceArray[index] = "\(Int.random(in: 1...numberOfSidesSelected))"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
