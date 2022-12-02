//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Kurt Lane on 2/12/2022.
//

import SwiftUI

struct LargeFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 70, design: .rounded).weight(.heavy))
    }
}

extension View {
    func prominentTitle() -> some View {
        modifier(LargeFont())
    }
}

struct ChoiceImage: View {
    var choice: String
    var body: some View {
        Text(choice)
            .font(.system(size: 200))
            .padding()
            .background(.ultraThinMaterial)
            .imageScale(.large)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ContentView: View {
    let choices = ["🪨","📃","✂️"]
    @State private var computerSelection = Int.random(in: 0...2)
    @State private var playerHasSelected = false
    @State private var currentScore = 0
    @State private var showSelectionResult = false
    @State private var scoreTitle = "✅" //❌
    @State private var messageText = ""
    @State private var tryToWin = Bool.random()
    @State private var round = 10
    @State private var showingGmeOverAlert = false
    
    var winOrLoseText: String {
        if tryToWin {return "WIN"}
        else {return "LOSE"}
    }
    
    var body: some View {
        ZStack {
            
            AngularGradient(colors: [.red,.orange,.yellow,.green,.blue,.indigo,.purple,.red], center: .center).ignoresSafeArea()
            
            VStack {
                Text("ROCK, PAPER, SCISSORS")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                    .padding()
                    .multilineTextAlignment(.center)
                
                VStack(spacing: -10) {
                    Text("Try to")
                    Text(winOrLoseText)
                        .prominentTitle()
                        .foregroundColor(tryToWin ? .green : .red)
                    Text("this round")
                }
                .foregroundColor(.white)
                .font(.system(.title2, design: .rounded).weight(.semibold))
                .multilineTextAlignment(.center)
                
                Spacer()
                
                Text(playerHasSelected ? choices[computerSelection] : "❓")
                    .font(.system(size: 200))
                    .padding()
                    .background(.ultraThinMaterial)
                    .imageScale(.large)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                
                Spacer()
                Spacer()
                
                HStack {
                    ForEach(choices, id: \.self) { chose in
                        Button(action: {selectionMade(chose)}) {    ChoiceImage(choice: chose)
                        }
                    }
                }
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .padding()
                
                Spacer()
                
                Text("Score: \(currentScore)")
                    .padding()
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    
                Spacer()
            }
            .alert(scoreTitle, isPresented: $showSelectionResult) {
                Button("OK", action: resetGame)
            } message: {
                Text(messageText)
            }
            .alert("Game Over", isPresented: $showingGmeOverAlert) {
                Button("Play again", action: {
                    round = 10
                    currentScore = 0
                    resetGame()
                })
            } message: {
                Text("Good game. After 10 rounds your score is \(currentScore)")
            }
        }
    }
    
    func resetGame() {
        if round > 0 {
            tryToWin = Bool.random()
            computerSelection = Int.random(in: 0...2)
            playerHasSelected = false
        } else {
            showingGmeOverAlert = true
        }
    }
 
    func selectionMade(_ chose: String) {
        switch chose {
        case "🪨":
            if tryToWin && choices[computerSelection] == "✂️" {
                currentScore += 1
                scoreTitle = "✅"
            } else if tryToWin == false && choices[computerSelection] == "📃" {
                currentScore += 1
                scoreTitle = "✅"
            } else {
                currentScore -= 1
                scoreTitle = "❌"
            }
        case "📃":
            if tryToWin && choices[computerSelection] == "🪨" {
                currentScore += 1
                scoreTitle = "✅"
            } else if tryToWin == false && choices[computerSelection] == "✂️" {
                currentScore += 1
                scoreTitle = "✅"
            } else {
                currentScore -= 1
                scoreTitle = "❌"
            }
        case "✂️":
            if tryToWin && choices[computerSelection] == "📃" {
                currentScore += 1
                scoreTitle = "✅"
            } else if tryToWin == false && choices[computerSelection] == "🪨" {
                currentScore += 1
                scoreTitle = "✅"
            } else {
                currentScore -= 1
                scoreTitle = "❌"
            }
        default: print("error")
        }
        messageText = "\nYou needed to \(winOrLoseText). You selected \(chose) and the computer selected \(choices[computerSelection]). \n\nYour current score is \(currentScore)"
        playerHasSelected = true
        round -= 1
        showSelectionResult = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
