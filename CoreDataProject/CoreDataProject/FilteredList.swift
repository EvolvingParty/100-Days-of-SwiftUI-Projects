//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Kurt Lane on 1/1/2023.
//

import SwiftUI
import CoreData

//struct FilteredList: View {
//    @FetchRequest var fetchRequest: FetchedResults<Singer>
//
//    var body: some View {
//        List {
//            ForEach(fetchRequest, id: \.self) { item in
//                Text("\(item.wrappedFirstName) \(item.wrappedLastName)")
//            }
//        }
//    }
//
//    init(filter: String) {
//        _fetchRequest = FetchRequest<Singer> (sortDescriptors: [], predicate: NSPredicate (format: "lastName BEGINSWITH %@", filter))
//    }
//}

enum PredicateType: String {
    case beginsWith = "BEGINSWITH"
    case contains = "CONTAINS"
    case containsCI = "CONTAINS[c]"
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>
    let centent: (T) -> Content
    
    var body: some View {
        List {
            ForEach(fetchRequest, id: \.self) { item in
                self.centent(item)
            }
        }
    }
    
    init(filterKey: String, predicateType: String, filterValue: String, @ViewBuilder centent: @escaping (T) -> Content) {
        _fetchRequest = FetchRequest<T> (sortDescriptors: [], predicate: NSPredicate(format: "%K \(predicateType) %@", filterKey, filterValue))
        self.centent = centent
    }
}
