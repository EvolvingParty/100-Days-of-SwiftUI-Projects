//
//  Habbits.swift
//  Habit Tracker
//
//  Created by Kurt Lane on 24/12/2022.
//

import Foundation

class Habbits: ObservableObject {
    @Published var habbitItems = [HabbitItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(habbitItems) {
                UserDefaults.standard.set(encoded, forKey: "HabbitItems")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "HabbitItems") {
            if let decodedItems = try? JSONDecoder().decode([HabbitItem].self, from: savedItems) {
                habbitItems = decodedItems
                return
            }
        }
        habbitItems = []
    }
    
    func newHabbitItem(name: String, description: String, habbitImage: String) {
        habbitItems.append(HabbitItem(name: name, description: description, habbitImage: habbitImage))
    }
}
