//
//  Result.swift
//  BucketList
//
//  Created by Kurt L on 13/1/2023.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Hashable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?

    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
    
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
}
