//
//  User.swift
//  Friends
//
//  Created by Kurt Lane on 3/1/2023.
//

import Foundation

public class Friend: NSObject, Codable, Identifiable {
    public let id: String
    let name: String
}

struct User: Codable, Identifiable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let address: String
    let email: String
    let about: String
    let registered: String
    let tags: [String]
    let friends: [Friend]
}
