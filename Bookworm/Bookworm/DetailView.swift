//
//  DetailView.swift
//  Bookworm
//
//  Created by Kurt Lane on 31/12/2022.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    let book: Book
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image (book.genre ?? "Fantasy")
                    .resizable()
                    .scaledToFit()
                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font (.caption)
                    .fontWeight(.black)
                    .padding (8)
                    .foregroundColor (.white)
                    .background(.black.opacity (0.75))
                    .clipShape (Capsule ( ))
                    .offset(x: -5, y: -5)
            }
            Text(book.author ?? "Unknown Author")
                .font(.system(.title, design: .rounded).weight(.semibold))
                .foregroundColor(.secondary)
            
            VStack {
                Text(book.review ?? "No review")
                HStack {
                    Spacer()
                    Text(book.date?.formatted(date: .abbreviated, time: .shortened) ?? Date().formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                }.padding(.top, 10)
            }
            .padding()
            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .navigationTitle (book.title ?? "Unknown Book" )
        .navigationBarTitleDisplayMode(.inline)
        .alert ("Delete book?", isPresented: $showingDeleteAlert) {
            Button ("Delete", role: .destructive, action: deleteBook)
            Button ("Cancel", role: .cancel, action: {})
        }
    }
    
    func deleteBook() {
        moc.delete(book)
        try? moc.save()
        dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(book: Book.sampleBook)
        }
    }
}
