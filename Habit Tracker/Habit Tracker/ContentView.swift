//
//  ContentView.swift
//  Habit Tracker
//
//  Created by Kurt Lane on 24/12/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var habits = Habits()
    @State var addNewHabitItem = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(habits.habitItems) { item in
                    HStack(alignment: .top) {
                        Text(item.habitImage)
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
            .navigationTitle("Habit Tracker")
        }
        .sheet(isPresented: $addNewHabitItem, content: {
            NewHabitView(habits: habits)
        })
    }
    
    func removeItems(at offsets: IndexSet) {
        habits.habitItems.remove(atOffsets: offsets)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
