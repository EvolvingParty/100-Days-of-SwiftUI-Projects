//
//  Habits.swift
//  Habit Tracker
//
//  Created by Kurt Lane on 24/12/2022.
//

import Foundation

class Habits: ObservableObject {
    @Published var habitItems = [HabitItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(habitItems) {
                UserDefaults.standard.set(encoded, forKey: "HabitItems")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "HabitItems") {
            if let decodedItems = try? JSONDecoder().decode([HabitItem].self, from: savedItems) {
                habitItems = decodedItems
                return
            }
        }
        habitItems = []
    }
    
    func newHabitItem(name: String, description: String, habitImage: String) {
        habitItems.append(HabitItem(name: name, description: description, habitImage: habitImage))
    }
}
