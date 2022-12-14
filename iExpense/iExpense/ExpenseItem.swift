//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Kurt Lane on 14/12/2022.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    let type: String
    let amount: Double
}
