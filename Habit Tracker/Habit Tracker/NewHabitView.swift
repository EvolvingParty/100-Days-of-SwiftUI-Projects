//
//  NewHabitView.swift
//  Habit Tracker
//
//  Created by Kurt Lane on 24/12/2022.
//

import SwiftUI

struct NewHabitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var habits: Habits
    @State private var name = ""
    @State private var description = ""
    @State private var dateStarted = Date()
    @State private var habitImage = "😇"
    @State private var showingEmojiPicker = false
    
    var body: some View {
        NavigationStack {
            Form {
                //Habit Image
                VStack {
                    HStack {
                        Spacer()
                        ZStack {
                            Text(habitImage)
                                .font(.system(size: 300.0))
                                .lineLimit(1)
                                .padding(30)
                                .minimumScaleFactor(0.1)
                            Circle()
                                .foregroundColor(.secondary.opacity(0.05))
                        }.frame(width: 160, height: 160)
                        Spacer()
                    }
                    Text("Edit")
                        .foregroundColor(.blue)
                }.listRowBackground(Color.clear)
                    .onTapGesture {
                        showingEmojiPicker = true
                    }
                Section {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                }
                Section {
                    HStack {
                        DatePicker("Date started", selection: $dateStarted, displayedComponents: .date)
                        DatePicker("", selection: $dateStarted, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .padding(.vertical)
                }
            }
            .sheet(isPresented: $showingEmojiPicker) {
                EmojiPickerView(selectedEmoji: $habitImage)
            }
            .navigationTitle("Add New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Save") {
                    habits.newHabitItem(name: name, description: description, habitImage: habitImage)
                    dismiss()
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

struct NewHabitView_Previews: PreviewProvider {
    static var previews: some View {
        NewHabitView(habits: Habits())
    }
}
