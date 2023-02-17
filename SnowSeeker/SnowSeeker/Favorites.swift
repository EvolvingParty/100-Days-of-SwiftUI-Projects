//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Paul Hudson on 25/01/2022.
//

import Foundation

class Favorites: ObservableObject {
    private var resorts: Set<String>
    private let saveKey = "Favorites"

    init() {
        // load our saved data
        if let data = UserDefaults.standard.data(forKey: "ResortsData") {
            if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
                resorts = decoded
                return
            }
        }
        resorts = []
    }

    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    func save() {
        // write out our data
        if let data = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.set(data, forKey: "ResortsData")
        }
    }
}
