//
//  ContentView.swift
//  Habit Tracker
//
//  Created by Kurt Lane on 24/12/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var habbits = Habbits()
    @State var addNewHabitItem = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(habbits.habbitItems) { item in
                    HStack(alignment: .top) {
                        Text(item.habbitImage)
                            .font(.system(size: 100))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .frame(width: 60.0, height: 60.0)
                            .padding(.vertical, 5)
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .lineLimit(1)
                                .font(.system(.title, design: .rounded).weight(.semibold))
                            Text(item.description)
                                .font(.system(.body, design: .rounded).weight(.semibold))
                                .foregroundColor(.secondary)
                        }.padding(.top, 6)
                    }
                }.onDelete(perform: removeItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        addNewHabitItem = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Habbit Tracker")
        }
        .sheet(isPresented: $addNewHabitItem, content: {
            NewHabbitView(habbits: habbits)
        })
    }
    
    func removeItems(at offsets: IndexSet) {
        habbits.habbitItems.remove(atOffsets: offsets)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
