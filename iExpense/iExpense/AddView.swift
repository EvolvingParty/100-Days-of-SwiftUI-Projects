//
//  AddView.swift
//  iExpense
//
//  Created by Kurt Lane on 14/12/2022.
//

import SwiftUI
import UIKit

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var date = Date()
    let types = ["Business", "Personal" ]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker ("Type", selection: $type) {
                    ForEach (types, id: \.self) {
                        Text ($0)
                    }
                }
                HStack {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .padding(.vertical)
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
                
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    if name == "" {
                        name = "unknown"
                    }
                    let item = ExpenseItem(date: date, name: name, type: type, amount: amount)
                    if item.type == "Personal" {
                        expenses.persoonalItems.append(item)
                    } else {
                        expenses.businessItems.append(item)
                    }
                    dismiss()
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
