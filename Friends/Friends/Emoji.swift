//
//  Emoji.swift
//  Habit Tracker
//
//  Created by Kurt Lane on 24/12/2022.
//

import Foundation

//struct Emoji: Codable, Identifiable {
//    var id: String
//    let description: String
//}
//

struct EmojiCategory:  Codable, Hashable {
    let category: String
    let emoji: [Emoji]
}

struct Emoji: Codable, Hashable {
    let emoji: String
    let description: String
    let category: String
}
