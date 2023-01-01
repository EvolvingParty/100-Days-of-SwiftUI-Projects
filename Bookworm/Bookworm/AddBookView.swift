//
//  AddBookView.swift
//  Bookworm
//
//  Created by Kurt Lane on 30/12/2022.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 0
    @State private var genre = ""
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance",
    "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author 's name", text: $author)
                    Picker ("Genre", selection: $genre) {
                        ForEach (genres, id: \.self) {
                            Text ($0)
                        }
                    }
                }
                Section {
                    TextEditor(text: $review)
                } header: {
                    Text ("Write a review")
                }
                Section {
                    HStack {
                        Spacer()
                        RatingView(rating: $rating)
                        Spacer()
                    }
//                    Picker("Rating", selection: $rating) {
//                        ForEach(0..<6) {
//                            Text(String ($0))
//                        }
//                    }
                } header: {
                    Text ("Rating")
                }
                Section {
                    Button ("Save") {
                        // add the book
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.date = Date.now
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review
                        try? moc.save()
                        dismiss()
                    }.disabled(!hasValidData)
                }
            }.navigationTitle("Add book")
        }
    }
    
    var hasValidData: Bool {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        return true
    }
    
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
