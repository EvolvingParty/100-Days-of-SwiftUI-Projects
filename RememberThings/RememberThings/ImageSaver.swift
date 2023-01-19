//
//  ImageSaver.swift
//  RememberThings
//
//  Created by Kurt L on 18/1/2023.
//

import UIKit

class ImageSaver: NSObject {
    
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingwithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Saved")
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
    
}
