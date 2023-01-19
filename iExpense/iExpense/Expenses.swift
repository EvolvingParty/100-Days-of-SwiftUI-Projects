//
//  Expenses.swift
//  iExpense
//
//  Created by Kurt Lane on 14/12/2022.
//

import Foundation

class Expenses: ObservableObject {
//    @Published var items = [ExpenseItem]() {
//        didSet {
//            let encoder = JSONEncoder()
//            if let encoded = try? encoder.encode(items) {
//                UserDefaults.standard.set(encoded, forKey: "Items")
//            }
//        }
//    }
    
    @Published var persoonalItems = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(persoonalItems) {
                UserDefaults.standard.set(encoded, forKey: "PersoonalItems")
            }
        }
    }
    
    @Published var businessItems = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(businessItems) {
                UserDefaults.standard.set(encoded, forKey: "BusinessItems")
            }
        }
    }
    
    init() {
        if let savedPersonalItems = UserDefaults.standard.data(forKey: "PersoonalItems") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedPersonalItems) {
                persoonalItems = decodedItems
                return
            }
            persoonalItems = []
        }
        if let savedBusinessItems = UserDefaults.standard.data(forKey: "BusinessItems") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedBusinessItems) {
                businessItems = decodedItems
                return
            }
            businessItems = []
        }
    }
    
}
