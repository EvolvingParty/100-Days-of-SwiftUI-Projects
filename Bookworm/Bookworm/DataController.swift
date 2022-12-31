//
//  DataController.swift
//  Bookworm
//
//  Created by Kurt Lane on 30/12/2022.
//

import Foundation
import CoreData

extension Book {
    static var sampleBook: Book {
        let persistenceController = DataController()
        let sampleBook = Book(context: persistenceController.container.viewContext)
        sampleBook.title = "Sample Book"
        sampleBook.author = "Sample Author"
        sampleBook.rating = 4
        sampleBook.id = UUID()
        sampleBook.genre = "Horror"
        sampleBook.review = """
"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris volutpat fermentum enim. Ut vitae urna odio. Suspendisse condimentum, arcu sed rhoncus auctor, dui nibh ultrices tortor, et elementum lorem ante eget mauris. Aenean tincidunt fringilla eros, sed sagittis ipsum volutpat ut. Donec fringilla mi sed nisl viverra, nec pretium tortor pretium. Nunc at ullamcorper est. Morbi ex ipsum, porttitor et lorem at, finibus pellentesque velit. In a convallis magna, fringilla fringilla mi.
        
        Nullam fringilla ut risus a cursus. Aliquam sed augue enim. Ut sagittis dignissim tincidunt. In hac habitasse platea dictumst. Pellentesque hendrerit aliquet mi vel finibus. Ut pharetra dictum felis vitae suscipit. Ut sed commodo eros, vel sodales justo.

        Duis ultricies congue sodales. Integer scelerisque turpis eu justo tempor malesuada. Nullam sit amet elementum eros. In condimentum quam enim, nec viverra nisi rutrum commodo. Pellentesque in enim at enim tempus euismod. Curabitur ac porta diam. Nulla facilisi. Phasellus at lacus ante. Nulla blandit urna nulla, eu varius mi gravida a. Cras sit amet bibendum ipsum. Pellentesque in massa et dui dapibus tristique. Fusce aliquam nunc in tortor faucibus, nec auctor tortor facilisis. Duis pharetra egestas dui at laoreet.

        Nunc eu velit facilisis, consequat enim ut, sollicitudin mauris. Phasellus nunc felis, tempus vel dolor et, auctor blandit dui. Sed eu tincidunt felis. Vestibulum quam mi, elementum id rhoncus vel, sagittis id justo. Nunc dictum diam quis massa lacinia, eget aliquet sapien bibendum. Donec at est ut ex lacinia finibus imperdiet non orci. Donec ullamcorper, metus id tristique dapibus, elit est iaculis tellus, in sodales ex eros sit amet ante. Duis rutrum libero vel metus maximus varius. Suspendisse quis pretium neque. Donec sed orci eu est consectetur vulputate. Suspendisse tempor vel sapien ac mattis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Cras viverra nisi urna, luctus tristique urna pulvinar in.

        Quisque vel scelerisque tortor. In vestibulum enim metus, eu tincidunt diam vestibulum eu. Fusce vestibulum tellus orci, in rutrum augue euismod id. Ut viverra vel erat sit amet eleifend. Nam sagittis sapien eu nisl tincidunt, eu finibus sem vehicula. Etiam finibus elit at tortor fermentum faucibus vel ac nisl. Suspendisse potenti. Sed vel volutpat elit. Pellentesque mollis mattis arcu, id tincidunt erat malesuada nec. Aliquam eget lacus leo.
"""
        return sampleBook
    }
}

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Bookworm")
    
    init() {
        container.loadPersistentStores { descriptoin, error in
            if let error = error {
                print("Coredata error \(error.localizedDescription)")
            }
        }
    }
}
