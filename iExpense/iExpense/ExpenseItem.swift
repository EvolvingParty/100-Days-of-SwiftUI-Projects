//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Kurt Lane on 14/12/2022.
//

import Foundation

struct ExpenseItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var date: Date = Date()
    let name: String
    let type: String
    let amount: Double
}
