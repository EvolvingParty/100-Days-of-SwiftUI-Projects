//
//  Emoji.swift
//  Habit Tracker
//
//  Created by Kurt Lane on 24/12/2022.
//

import Foundation

struct Emoji: Codable, Identifiable {
    var id: String
    let description: String
    let category: String
}
