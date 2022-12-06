//
//  ContentView.swift
//  WordScramble
//
//  Created by Kurt Lane on 6/12/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var rootWord = ""
    @State private var arrayOfUsedWords = [String]()
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var eerorMessage = ""
    @State private var showingError = false
    
    func startGame() {
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
                            Text(word)
                        }
                    }
                }
            }
            .onAppear(perform: startGame)
            //.navigationTitle("Word Scramble")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .center, spacing: -5) {
                        Divider().opacity(0.0).frame(height: 15.0)
                        Text("Your word is").font(.subheadline)
                        Text(rootWord.lowercased()).font(.system(.largeTitle, design: .rounded).weight(.bold))
                    }
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
        guard answer.count > 0 else {return}
        
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
