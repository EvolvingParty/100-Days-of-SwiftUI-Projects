//
//  HabitItem.swift
//  Habit Tracker
//
//  Created by Kurt Lane on 24/12/2022.
//

import Foundation
import SwiftUI

struct HabitItem: Codable, Identifiable {
    var id: UUID = UUID()
    var dateStarted: Date = Date()
    let name: String
    let description: String
    let habitImage: String
    var completionCount: Int = 0
    //var habitColour: Color = Color.turquoise //Type 'HabitItem' does not conform to protocol 'Encodable'
}
