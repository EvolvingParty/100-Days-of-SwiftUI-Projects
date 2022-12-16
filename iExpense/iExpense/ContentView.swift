//
//  ContentView.swift
//  iExpense
//
//  Created by Kurt Lane on 13/12/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    func amountTextColour(_ amount: Double) -> Color {
        if amount > 10.0 && amount <= 100.0 {
            return .orange
        } else if amount > 100.0 {
            return .red
        }
        return .primary
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header:
                            Text("Personal Expenses")
                    .padding(.leading, -20)
                    .padding(.bottom, 5)
                ) {
                    ForEach(expenses.persoonalItems, id: \.self) { item in
                        expenseItemRow(item)
                    }
                    .onDelete(perform: removePersoanlItems)
                }
                Section(header:
                            Text("Business Expenses")
                    .padding(.leading, -20)
                    .padding(.bottom, 5)
                ) {
                    ForEach(expenses.businessItems, id: \.self) { item in
                        expenseItemRow(item)
                    }
                    .onDelete(perform: removeBusinessItems)
                }
//                ForEach(expenses.items) { item in
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text(item.name)
//                                .font(.headline)
//                            Text(item.date.formatted(date: .numeric, time: .shortened))
//                                .font(.callout)
//                                .foregroundColor(.secondary)
//                        }.padding(EdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0))
//                        Spacer()
//                        VStack(alignment: .trailing) {
//                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
//                                .foregroundColor(amountTextColour(item.amount))
//                            Text(item.type)
//                                .font(.footnote)
//                                .foregroundColor(.secondary)
//                        }
//
//                    }
//                }
//                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
//                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5.0)
//                    expenses.items.append(expense)
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removePersoanlItems(at offsets: IndexSet) {
        expenses.persoonalItems.remove(atOffsets: offsets)
    }
    
    func removeBusinessItems(at offsets: IndexSet) {
        expenses.businessItems.remove(atOffsets: offsets)
    }
    
    @ViewBuilder
    func expenseItemRow(_ item: ExpenseItem) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.date.formatted(date: .numeric, time: .shortened))
                    .font(.callout)
                    .foregroundColor(.secondary)
            }.padding(EdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0))
            Spacer()
            VStack(alignment: .trailing) {
                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .foregroundColor(amountTextColour(item.amount))
                Text(item.type)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
