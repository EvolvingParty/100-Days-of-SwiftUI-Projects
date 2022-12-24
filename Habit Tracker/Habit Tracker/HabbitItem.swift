//
//  HabbitItem.swift
//  Habit Tracker
//
//  Created by Kurt Lane on 24/12/2022.
//

import Foundation
import SwiftUI

struct HabbitItem: Codable, Identifiable {
    var id: UUID = UUID()
    var dateStarted: Date = Date()
    let name: String
    let description: String
    let habbitImage: String
    var completionCount: Int = 0
    //var habbitColour: Color = Color.turquoise //Type 'HabbitItem' does not conform to protocol 'Encodable'
}
