//
//  ContentView.swift
//  WordScramble
//
//  Created by Kurt on 6/12/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var score = 0
    
    @State private var rootWord = ""
    @State private var arrayOfUsedWords = [String]()
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var eerorMessage = ""
    @State private var showingError = false
    
    func startGame() {
        arrayOfUsedWords = []
        score = 0
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWrods = try? String(contentsOf: startWordsURL) {
                let allWords = startWrods.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from app bundle")
    }
//    static var selectedWord: String {
//        var wordToReturn = "*!%$"
//        if let fileURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
//            // File found, now use it
//            if let fileContents = try? String(contentsOf: fileURL) {
//                // Now use the string
//                let wordsArray = fileContents.components(separatedBy: "\n")
//                let randomWord = wordsArray.randomElement() ?? "*!%$"
//                let checker = UITextChecker()
//                let range = NSRange(location: 0, length: randomWord.utf16.count)
//                let misspelledRange = checker.rangeOfMisspelledWord(in: randomWord, range: range, startingAt: 0, wrap: false, language: "en")
//                //let allGood = misspelledRange.location == NSNotFound
//                if misspelledRange.location == NSNotFound {
//                    wordToReturn = randomWord
//                } else {
//
//                }
//            }
//        }
//        return wordToReturn
//    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Please enter a word", text: $newWord)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                }
                Section {
                    ForEach(arrayOfUsedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle.fill")
                                .imageScale(.large)
                                .padding(.vertical, 5)
                            Text(word)
                        }
                        .accessibilityElement() //ignores by default
                        .accessibilityLabel("\(word), \(word.count) letters")
                    }
                }
            }
            .onAppear(perform: startGame)
            //.navigationTitle("Word Scramble")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    VStack(alignment: .center, spacing: -3) {
                        Text("Score")
                            .font(.footnote)
                        Text(score, format: .number).font(.system(.largeTitle, design: .rounded).weight(.bold))
                            .foregroundColor(.blue)
                    }
                    .padding(.leading, 15)
                    .padding(.top, 15)
                    .accessibilityElement(children: .combine)
                })
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        startGame()
                    }) {
                        VStack(alignment: .center, spacing: 4) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(.headline, design: .rounded).weight(.black))
                            Text("Refresh")
                                .font(.footnote).fontWeight(.light)
                                .foregroundColor(.primary)
                        }
                        .padding(.trailing, 15)
                        .padding(.top, 15)
                    }
                })
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .center, spacing: -5) {
                        Text("Your word is").font(.subheadline).fontWeight(.semibold)
                            .padding(.top, 15)
                        Text(rootWord.lowercased()).font(.system(.largeTitle, design: .rounded).weight(.bold))
                            .foregroundColor(.blue)
                    }.accessibilityElement(children: .combine)
                }
            }
            .onSubmit {
                addNewWord()
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(eerorMessage)
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer != rootWord else  {
            newWord = ""
            return
        }
        
        guard answer.count > 2 else {
            wordError(title: "Too short", message: "Words need to have 3 or more letters")
            return
        }
        
        //Extra validation to come
        guard isOriginal(answer) else {
            wordError(title: "Word already used", message: "Enter a different word")
            return
        }
        guard isPossible(answer) else {
            wordError(title: "Word not possible", message: "You cannot spell that word from \(rootWord)")
            return
        }
        guard isRealWord(answer) else {
            wordError(title: "Word not recognised", message: "That word does not exist in dictionary")
            return
        }
        
        withAnimation{
            arrayOfUsedWords.insert(answer, at: 0)
        }
        score = score + answer.count
        newWord = ""
    }
    
    func isOriginal(_ word: String) -> Bool {
        !arrayOfUsedWords.contains(word)
    }
    
    func isPossible(_ word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isRealWord(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        //let allGood = misspelledRange.location == NSNotFound
//        if misspelledRange.location == NSNotFound {
//            return true
//        } else {
//            return false
//        }
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        eerorMessage = message
        showingError = true
    }
    
    //
    //    func loadFile() {
    //        if let fileURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
    //            // File found, now use it
    //            if let fileContents = try? String(contentsOf: fileURL) {
    //                // Now use the string
    //            }
    //        }
    //    }
    
    //    let letters = input. components(separatedBy: "\n")
    //    let letter = letters.randomElement()
    //    let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
