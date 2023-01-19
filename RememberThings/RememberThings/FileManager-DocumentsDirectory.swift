//
//  FileManager-DocumentsDirectory.swift
//  RememberThings
//
//  Created by Kurt L on 18/1/2023.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

