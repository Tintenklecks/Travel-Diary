//
//  Caching.swift
//  Travel Diary
//
//  Created by Ingo Böhme on 01.08.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import Foundation
import UIKit

class Caching {
    static let cacheUrl = FileManager.documentDirectoryURL.appendingPathComponent("images")
    
    static func cacheImageFileUrl(id: String, width: CGFloat = 150, height: CGFloat = 150) -> URL? {
        let filename = String(id.replacingOccurrences(of: "/", with: "..."))
        return cacheUrl.appendingPathComponent("\(filename)w\(Int(width))h\(Int(height)).jpg")
    }
    
    static func cachedImage(id: String, width: CGFloat = 150, height: CGFloat = 150) -> UIImage? {
        if !FileManager.default.fileExists(atPath: cacheUrl.path) {
            try? FileManager.default.createDirectory(at: cacheUrl, withIntermediateDirectories: true, attributes: nil)
        }
        
        if let fileUrl = cacheImageFileUrl(id: id, width: width, height: height),
            FileManager.default.fileExists(atPath: fileUrl.path),
            let image = UIImage(contentsOfFile: fileUrl.path) {
            return image
        }
        
        return nil
    }
    
    static func getImage(with id: String, width: CGFloat = 150, height: CGFloat = 150, closure: (UIImage) -> () = { _ in }) {
        if let image = cachedImage(id: id, width: width, height: height) {
            closure(image)
        }
    }
    
    static func saveImageToCache(id: String, image: UIImage, width: CGFloat = 150, height: CGFloat = 150) {
        guard let fileUrl = cacheImageFileUrl(id: id, width: width, height: height),
            !FileManager.default.fileExists(atPath: fileUrl.path) else {
            return
        }
        if let data = image.jpegData(compressionQuality: 0.9) {
            do {
                try data.write(to: fileUrl)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    static func clearImageCache() {
        try? FileManager.default.removeItem(at: cacheUrl)

        
    }
}
