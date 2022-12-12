//
//  ContentView.swift
//  Multiplication Edutainment App
//
//  Created by Kurt Lane on 11/12/2022.
//

///100 Days of SwiftUI – Hacking with Swift, DAY 35
///https://www.hackingwithswift.com/guide/ios-swiftui/3/3/challenge
///Build an “edutainment” app for kids to help them practice multiplication tables – “what is 7 x 8?” and so on
///*The player needs to select which multiplication tables they want to practice. This could be pressing buttons, or it could be an “Up to…” stepper, going from 2 to 12.
///*The player should be able to select how many questions they want to be asked: 5, 10, or 20.
///*You should randomly generate as many questions as they asked for, within the difficulty range they asked for.

import SwiftUI

struct ContentView: View {
    @State private var timesTablesSelected = 0
    @State private var numberOfQuestionsSelected = 5
    var numberOfQuestionsOptions = [5,10,20]
    @State private var currentScore = 0
    @State private var currentQuestionNumber = 1
    @State private var numberOfAnimals = 1
    
    @State private var randomAnimal = animalList.randomElement()
    
    @State private var correctAnswerArray: [Bool] = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,]
    
    @State private var possibleAnswersArray = [1,2,3,4]
    @State private var questionsArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    
    static var animalList = ["bear","buffalo","chick","chicken","cow"]
    
    @State private var dragAmountArray = [CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero]
    
    var body: some View {
        VStack {
            HStack {
                Picker("Multiplication table", selection: $timesTablesSelected, content: {
                    ForEach((2..<13), content: {
                        Text("\($0) x tables")
                    })
                })
                Picker("Number of questions", selection: $numberOfQuestionsSelected, content: {
                    ForEach(numberOfQuestionsOptions, id: \.self) {
                        Text("\($0) questions")
                    }
                })
            }
            .onChange(of: numberOfQuestionsSelected, perform: { _ in
                resetGame()
            })
            .onChange(of: timesTablesSelected, perform: { _ in
                resetGame()
            })
            
            Text("QUESTION \(currentQuestionNumber):")
                .font(.system(.title, design: .rounded).weight(.bold))
                .foregroundColor(.secondary)
                .padding(.top, 10)
            
            Text("\(questionsArray[currentQuestionNumber-1]) x \(timesTablesSelected+2)")
                .font(.system(.largeTitle, design: .rounded).weight(.bold))
            
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.yellow).opacity(0.1)
                    .frame(height: .infinity)
                ForEach(0..<numberOfAnimals, id: \.self) { int in
                    Image(randomAnimal ?? "cow")
                        .resizable()
                        .frame(width: 60.0, height: 60.0)
                        .offset(dragAmountArray[int])
                        .gesture(
                            DragGesture()
                                .onChanged { dragAmountArray[int] = $0.translation }
                                //.onEnded { _ in dragAmount = .zero }
                        )
                }
                VStack {
                    Spacer()
                    Stepper("", value: $numberOfAnimals)
                        .labelsHidden()
                        .padding(.bottom)
                }
            }

            Spacer()
            
            Text("SELECT ANSWER")
                .font(.system(.title, design: .rounded).weight(.bold))
                .foregroundColor(.secondary)
                .padding(.top, 10)
            
            HStack(spacing: 20) {
                Button(action: {
                    tappedAnswer(possibleAnswersArray[0])
                }) {
                    Text(possibleAnswersArray[0], format: .number)
                        .font(.system(.title, design: .rounded).weight(.bold))
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                }
                Button(action: {
                    tappedAnswer(possibleAnswersArray[1])
                }) {
                    Text(possibleAnswersArray[1], format: .number)
                        .font(.system(.title, design: .rounded).weight(.bold))
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                }

                Button(action: {
                    tappedAnswer(possibleAnswersArray[2])
                }) {
                    Text(possibleAnswersArray[2], format: .number)
                        .font(.system(.title, design: .rounded).weight(.bold))
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                }
                Button(action: {
                    tappedAnswer(possibleAnswersArray[3])
                }) {
                    Text(possibleAnswersArray[3], format: .number)
                        .font(.system(.title, design: .rounded).weight(.bold))
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                }
            }.padding(EdgeInsets(top: 0, leading: 25, bottom: 10, trailing: 25))
            
            VStack {
                Text("SCORE \(currentScore) / \(numberOfQuestionsSelected)")
                    .padding(.bottom, 5)
                    .foregroundColor(.secondary)
                    .font(.system(.title, design: .rounded).weight(.bold))
                HStack {
                    Image(systemName: "star.fill")
                        .opacity(correctAnswerArray[0] == true ? 1.0 : 0.1)
                        .foregroundColor(correctAnswerArray[0] == true ? .yellow : .black)
                    Image(systemName: "star.fill")
                        .opacity(correctAnswerArray[1] == true ? 1.0 : 0.1)
                        .foregroundColor(correctAnswerArray[1] == true ? .yellow : .black)
                    Image(systemName: "star.fill")
                        .opacity(correctAnswerArray[2] == true ? 1.0 : 0.1)
                        .foregroundColor(correctAnswerArray[2] == true ? .yellow : .black)
                    Image(systemName: "star.fill")
                        .opacity(correctAnswerArray[3] == true ? 1.0 : 0.1)
                        .foregroundColor(correctAnswerArray[3] == true ? .yellow : .black)
                    Image(systemName: "star.fill")
                        .opacity(correctAnswerArray[4] == true ? 1.0 : 0.1)
                        .foregroundColor(correctAnswerArray[4] == true ? .yellow : .black)
                }
                if numberOfQuestionsSelected > 5 {
                    HStack {
                        Image(systemName: "star.fill")
                            .opacity(correctAnswerArray[5] == true ? 1.0 : 0.1)
                            .foregroundColor(correctAnswerArray[5] == true ? .yellow : .black)
                        Image(systemName: "star.fill")
                            .opacity(correctAnswerArray[6] == true ? 1.0 : 0.1)
                            .foregroundColor(correctAnswerArray[6] == true ? .yellow : .black)
                        Image(systemName: "star.fill")
                            .opacity(correctAnswerArray[7] == true ? 1.0 : 0.1)
                            .foregroundColor(correctAnswerArray[7] == true ? .yellow : .black)
                        Image(systemName: "star.fill")
                            .opacity(correctAnswerArray[8] == true ? 1.0 : 0.1)
                            .foregroundColor(correctAnswerArray[8] == true ? .yellow : .black)
                        Image(systemName: "star.fill")
                            .opacity(correctAnswerArray[9] == true ? 1.0 : 0.1)
                            .foregroundColor(correctAnswerArray[9] == true ? .yellow : .black)
                    }
                    if numberOfQuestionsSelected > 10 {
                        HStack {
                            Image(systemName: "star.fill")
                                .opacity(correctAnswerArray[10] == true ? 1.0 : 0.1)
                                .foregroundColor(correctAnswerArray[10] == true ? .yellow : .black)
                            Image(systemName: "star.fill")
                                .opacity(correctAnswerArray[11] == true ? 1.0 : 0.1)
                                .foregroundColor(correctAnswerArray[11] == true ? .yellow : .black)
                            Image(systemName: "star.fill")
                                .opacity(correctAnswerArray[12] == true ? 1.0 : 0.1)
                                .foregroundColor(correctAnswerArray[12] == true ? .yellow : .black)
                            Image(systemName: "star.fill")
                                .opacity(correctAnswerArray[13] == true ? 1.0 : 0.1)
                                .foregroundColor(correctAnswerArray[13] == true ? .yellow : .black)
                            Image(systemName: "star.fill")
                                .opacity(correctAnswerArray[14] == true ? 1.0 : 0.1)
                                .foregroundColor(correctAnswerArray[14] == true ? .yellow : .black)
                        }
                        HStack {
                            Image(systemName: "star.fill")
                                .opacity(correctAnswerArray[15] == true ? 1.0 : 0.1)
                                .foregroundColor(correctAnswerArray[15] == true ? .yellow : .black)
                            Image(systemName: "star.fill")
                                .opacity(correctAnswerArray[16] == true ? 1.0 : 0.1)
                                .foregroundColor(correctAnswerArray[16] == true ? .yellow : .black)
                            Image(systemName: "star.fill")
                                .opacity(correctAnswerArray[17] == true ? 1.0 : 0.1)
                                .foregroundColor(correctAnswerArray[17] == true ? .yellow : .black)
                            Image(systemName: "star.fill")
                                .opacity(correctAnswerArray[18] == true ? 1.0 : 0.1)
                                .foregroundColor(correctAnswerArray[18] == true ? .yellow : .black)
                            Image(systemName: "star.fill")
                                .opacity(correctAnswerArray[19] == true ? 1.0 : 0.1)
                                .foregroundColor(correctAnswerArray[19] == true ? .yellow : .black)
                        }
                    }
                }
            }
            .padding(.top, 15)
            .padding(.bottom, 25)
            .font(.system(.largeTitle, design: .rounded).weight(.bold))
            .lineLimit(4)
        }
        .onAppear(perform: {
            generateQuestionsArray()
            calculatePossibleAnswerArray()
            numberOfAnimals = questionsArray[currentQuestionNumber-1]
        })
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    func alert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
    
    func generateQuestionsArray() {
        var possibleQuestionsArray = [Int]()
        if numberOfQuestionsSelected <= 10 {
            for x in 1...12 {
                possibleQuestionsArray.append(x)
            }
        } else {
            for x in 1...20 {
                possibleQuestionsArray.append(x)
            }
        }
        possibleQuestionsArray.shuffle()
        var arrayToReturn = [Int]()
        for x in 0..<numberOfQuestionsSelected {
            arrayToReturn.append(possibleQuestionsArray[x])
        }
        print("questionsArray \(arrayToReturn)")
        questionsArray = arrayToReturn
    }
    
    func calculatePossibleAnswerArray() {
//        possibleAnswersArray = [questionsArray[currentQuestionNumber]
//                                    ,2,3,4]
        var answersArrayToReturn = [Int]()
        let answer = questionsArray[currentQuestionNumber-1] * (timesTablesSelected+2)
        answersArrayToReturn.append(answer)
        
        repeat {
            let randomAnswer = (timesTablesSelected+2)*Int.random(in: 1...20)
            if answersArrayToReturn.contains(randomAnswer) {
            } else {
                answersArrayToReturn.append(randomAnswer)
            }
        } while answersArrayToReturn.count < 4

        possibleAnswersArray = answersArrayToReturn.shuffled()
    }
    
    func resetGame() {
        currentQuestionNumber = 1
        generateQuestionsArray()
        calculatePossibleAnswerArray()
        resetDragAmount()
        correctAnswerArray = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,]
        currentScore = 0
    }
    
    func resetDragAmount() {
        withAnimation {
            numberOfAnimals = questionsArray[currentQuestionNumber-1]
            randomAnimal = ContentView.animalList.randomElement()
            dragAmountArray = [CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero,CGSize.zero]
        }
    }
    
    func tappedAnswer(_ value: Int) {
        print("User tapped \(value)")
        if value == questionsArray[currentQuestionNumber-1] * (timesTablesSelected+2) {
            //Corrent
            correctAnswerArray.remove(at: currentQuestionNumber-1)
            correctAnswerArray.insert(true, at: currentQuestionNumber-1)
            currentScore += 1
            alert(title: "✅", message: "CORRECT")
        } else {
            //incorrect
            alert(title: "❌", message: "You selected \(value). The correct answer was \(questionsArray[currentQuestionNumber-1] * (timesTablesSelected+2))")
        }
        if currentQuestionNumber < numberOfQuestionsSelected {
            currentQuestionNumber += 1
            calculatePossibleAnswerArray()
            resetDragAmount()
            numberOfAnimals = questionsArray[currentQuestionNumber-1]
        } else {
            print("Game Over")
            alert(title: "Game Over", message: "You scored \(currentScore) out of \(numberOfQuestionsSelected)")
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
