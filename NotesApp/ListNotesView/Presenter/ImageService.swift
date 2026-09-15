//
//  ImageService.swift
//  NotesApp
//
//  Created by Дима Люфт on 21.07.2026.
//

import UIKit

protocol ImageServiceProtocol:AnyObject {
    func loadImage(name: String) -> UIImage?
}

final class ImageService: ImageServiceProtocol {
    
    private let coreManager = CoreManager.shared
    
    func loadImage(name: String) -> UIImage? {
        guard let data = coreManager.readFile(imageName: name),
                let image = UIImage(data: data) else {
            return UIImage(systemName: "photo")
        }
        return image.circularImage()
    }
}
