//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Kurt on 27/11/2022.
//

import SwiftUI

struct LargeBlueFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
            .font(.system(.largeTitle, design: .rounded).weight(.bold))
    }
}

extension View {
    func prominentTitle() -> some View {
        modifier(LargeBlueFont())
    }
}

struct FlagImage: View {
    var country: String
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    
    @State private var showingGameOver = false
    @State private var currentQuestion = 1
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    let labels = [
    "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
    "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
    "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
    "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
    "Italy": "Flag with three vertical stripes of equal size. teft stripe green, middle stripe white, right stripe red",
    "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
    "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
    "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
    "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
    "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
    "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var tappedAnswer = 0
    @State private var rotationAmount = 0.0
    @State private var opacityAmount = 1.0
    @State private var scaleAmount = 1.0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                    .padding(.bottom, 20)
                VStack(spacing: 15.0) {
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.system(.title2, design: .rounded).weight(.semibold))
                        Text(countries[correctAnswer])
                            //.foregroundColor(.primary)
                            //.font(.system(.largeTitle, design: .rounded).weight(.bold))
                            .prominentTitle()
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            tappedAnswer = number
                            flagTapped(tappedAnswer)
                            withAnimation {
                                rotationAmount = 360
                                opacityAmount = 0.25
                                scaleAmount = 0.1
                            }
                        } label: {
                            FlagImage(country: countries[number])
                                .opacity(number == tappedAnswer ? 1.0 : opacityAmount)
                                .rotation3DEffect(.degrees(number == tappedAnswer ? rotationAmount : 0), axis: (x: 0, y: 1, z: 0))
                                .scaleEffect(number == tappedAnswer ? 1.0 : scaleAmount)
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(currentScore)")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                    .padding(.top, 20)
                
                Spacer()
                
            }.padding()
        }.alert(scoreTitle, isPresented: $showingScore) {
            Button("OK", action: askQuestion)
        } message: {
            Text("Your scroe is \(currentScore)")
        }
        .alert("Game Over", isPresented: $showingGameOver, actions: {
            Button("Replay", role: .none, action: {
                resetGame()
            })
        }, message: { Text("Game over. You scoreed \(currentScore) out of a possible 8.") })
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
        } else {
            scoreTitle = "Incorrect. The flag you tapped was \(countries[number])"
        }
        if currentQuestion < 8 {
            showingScore = true
        } else {
            showingGameOver = true
        }
    }
    
    func resetGame() {
        currentQuestion = 0
        currentScore = 0
        askQuestion()
    }
    
    func askQuestion() {
        scaleAmount = 1.0
        opacityAmount = 1.0
        rotationAmount = 0.0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        currentQuestion += 1
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
