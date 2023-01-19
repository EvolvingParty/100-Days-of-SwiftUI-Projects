//
//  Thing+CoreDataProperties.swift
//  RememberThings
//
//  Created by Kurt L on 19/1/2023.
//
//

import Foundation
import CoreData
import SwiftUI

extension Thing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Thing> {
        return NSFetchRequest<Thing>(entityName: "Thing")
    }

    @NSManaged public var dateTime: Date?
    @NSManaged public var imageUUID: String?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    
    public var wrappedName: String {
        name ?? "No name"
    }
    
    public var wrappedNotes: String {
        notes ?? ""
    }
    
    public var wrappedDateTime: String {
        if let wrappedDateTime = dateTime {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: wrappedDateTime)
        } else { return "Unknown" }
    }
    
    public var wrappedImage: Image {
        if let imageUUID = imageUUID {
            do {
                let savedPath = FileManager.documentsDirectory.appendingPathComponent(imageUUID)
                let data = try Data(contentsOf: savedPath)
                let uiImageData = try JSONDecoder().decode(Data.self, from: data)
                if let UIImage = UIImage(data: uiImageData) {
                    return Image(uiImage: UIImage)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return Image("no-image-available")
    }
    
}

extension Thing : Identifiable {

}
