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

struct LocationResult: Codable {
    let query: LocationQuery
}

struct LocationQuery: Codable {
    let geosearch: [LocationPage]
}

struct LocationPage: Codable, Hashable, Comparable {
    let pageid: Int
    let title: String
    let lat: Double
    let lon: Double
    let dist: Double

    static func < (lhs: LocationPage, rhs: LocationPage) -> Bool {
        lhs.dist < rhs.dist
    }
    
//    var description: String {
//        terms?["description"]?.first ?? "No further information"
//    }
}
