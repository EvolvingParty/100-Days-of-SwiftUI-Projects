//
//  NewHabbitView.swift
//  Habit Tracker
//
//  Created by Kurt Lane on 24/12/2022.
//

import SwiftUI

struct NewHabbitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var habbits: Habbits
    @State private var name = ""
    @State private var description = ""
    @State private var dateStarted = Date()
    @State private var habbitImage = "😇"
    
    var body: some View {
        NavigationStack {
            Form {
                //Habit Image
                VStack {
                    HStack {
                        Spacer()
                        ZStack {
                            Text(habbitImage)
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
            .navigationTitle("Add New Habbit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Save") {
                    habbits.newHabbitItem(name: name, description: description, habbitImage: habbitImage)
                    dismiss()
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

struct NewHabbitView_Previews: PreviewProvider {
    static var previews: some View {
        NewHabbitView(habbits: Habbits())
    }
}
