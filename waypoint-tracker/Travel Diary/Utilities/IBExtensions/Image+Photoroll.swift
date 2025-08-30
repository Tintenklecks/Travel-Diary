//
#if !os(watchOS)
import Foundation
import PhotosUI
import SwiftUI

public extension UIImage {
    static func photorollCount(inRange startDate: Date, endDate: Date, closure: @escaping (Int) -> ()) {
        PHPhotoLibrary.requestAuthorization { authStatus in
            if authStatus == .authorized {
                // Fetch the images between the start and end date
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", startDate as NSDate, endDate as NSDate)

                let imageAsset = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                closure(imageAsset.count)
            }
        }
    }

    static func photorollIdentifiers(inRange startDate: Date, endDate: Date, onUpdate: @escaping ([String]) -> ()) {
        var assetIdentifiers: [String] = []

        PHPhotoLibrary.requestAuthorization { authStatus in
            if authStatus == .authorized {
                // Fetch the images between the start and end date
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", startDate as NSDate, endDate as NSDate)

                let asset = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                for index in 0..<asset.count {
                    let asset = asset[index]
                    assetIdentifiers.append(asset.localIdentifier)
                }

                onUpdate(assetIdentifiers)
            }
        }
    }

    static func photoroll(with identifiers: [String], width: CGFloat = 150, height: CGFloat = 150, onUpdate: @escaping (String, UIImage, Date?, Double?, Double?) -> ()) {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)

        // TODO: -Remove comments-
        #if targetEnvironment(simulator)
        if assets.count == 0 { return }
        let i = Int.random(in: 0..<assets.count)
        let range = i...i
        #else
        let range = 0..<assets.count
        #endif

        for index in range { // TODO: ***
            let asset = assets[index]
            let imageId: String = index < identifiers.count ? identifiers[index] : UUID().uuidString 

            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.version = .current
            options.isSynchronous = true
            options.isNetworkAccessAllowed = true

            manager.requestImage(for: asset, targetSize: CGSize(width: width, height: height), contentMode: .aspectFit, options: options) { image, whatsoever in

                if let image = image {
                    onUpdate(imageId, image, asset.creationDate, asset.location?.coordinate.latitude, asset.location?.coordinate.longitude)
                } else {
                    print("ERROR - \(imageId) - \(whatsoever.debugDescription)")
                }
            }
        }
    }
}
#endif
