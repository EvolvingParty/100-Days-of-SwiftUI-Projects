//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Kurt Lane on 17/12/2022.
//

import Foundation

extension Bundle {
    
//    func decode(_ file: String) -> [String: Astronaut] {
//        guard let url = self.url(forResource: file, withExtension: nil) else {
//            fatalError("Failed to loacte \(file)")
//        }
//        guard let data = try? Data(contentsOf: url) else {
//            fatalError("Failed to load \(file)")
//        }
//        let decoder = JSONDecoder()
//        guard let loaded = try? decoder.decode([String: Astronaut].self, from: data) else {
//            fatalError("Failed to decode \(file)")
//        }
//        return loaded
//    }
    
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to loacte \(file)")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file)")
        }
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file)")
        }
        return loaded
    }
    
}
