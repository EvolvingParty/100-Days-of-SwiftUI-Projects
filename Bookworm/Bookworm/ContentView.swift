//
//  ContentView.swift
//  Bookworm
//
//  Created by Kurt Lane on 30/12/2022.
//

import SwiftUI

//PushButton View App
struct PushButton: View {
    let title: String
    @Binding var isOn: Bool
    var onColors = [Color.red, Color.yellow]
    var offColors = [Color (white: 0.6), Color (white: 0.4)]
    
    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        .background(
            LinearGradient(colors: isOn ? onColors: offColors, startPoint: .top, endPoint: .bottom)
        )
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct PushButtonView: View {
    @State private var rememberMe = false
    var body: some View {
        VStack {
            PushButton(title: "Remember Me", isOn: $rememberMe)
            Text(rememberMe ? "On" : "Off")
        }
    }
}

//Text Editor
struct TextEditorView: View {
    @AppStorage("notes") private var notes = ""
    var body: some View {
        NavigationView {
            TextEditor(text: $notes)
                .navigationTitle("Notes")
                .padding ()
        }
    }
}


//CoreData
struct CoreDataView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student>
    var body: some View {
        VStack {
            List(students) { student in
                Text(student.name ?? "Unknown")
            }
            Button("Add") {
                let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
                let lastNames = [ "Granger", "Lovegood", "Potter", "Weasley"]
                let chosenFirstName = firstNames.randomElement()!
                let chosenLastName = lastNames.randomElement()!
                
                let newStudent = Student(context: moc)
                newStudent.id = UUID()
                newStudent.name = "\(chosenFirstName) \(chosenLastName)"
                try? moc.save()
            }
        }
    }
}

//Bookworm App
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("Bookworm App")
        PushButtonView()
            .previewDisplayName("Push Button")
        TextEditorView()
            .previewDisplayName("Text Editor")
        CoreDataView()
            .previewDisplayName("Core Data")
    }
}
