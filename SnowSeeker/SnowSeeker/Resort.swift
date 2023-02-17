//
//  Resort.swift
//  SnowSeeker
//
//  Created by Kurt L on 12/2/2023.
//

import Foundation

struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
    
    var facilityTypes: [Facility] {
        facilities.map(Facility.init)
    }
    
    //static let is automatically lazy and will be run in the corect order
//    static let allResorts: [Resort] = Bundle.main.decode("resorts.¡son")
//    static let example = allResorts[0]
    // or
    static let example = (Bundle.main.decode("resorts.json") as [Resort])[0]
    
}
