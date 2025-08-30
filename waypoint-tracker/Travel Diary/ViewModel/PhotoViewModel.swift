import Combine
import CoreLocation
import Foundation
import PhotosUI

import SwiftUI

#if os(iOS)
import RealmSwift
#endif
class IdentifiableImage: Identifiable {
    let id: String
    var image: Image {
        return Image(uiImage: uiImage)
    }
    
    var timeStamp: Date?
    var latitude: Double?
    var longitude: Double?
    
    let uiImage: UIImage
    
    init(id: String, image: UIImage, timeStamp: Date? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = id
        self.uiImage = image
        self.timeStamp = timeStamp
        self.latitude = latitude
        self.longitude = longitude
    }
}

class PhotoViewModel: ObservableObject {
    @Published var photos: [IdentifiableImage] = []
    
    var uiImages: [UIImage] {
        return photos.map { $0.uiImage }
    }
    
    var images: [Image] {
        return photos.map { $0.image }
    }
    
    private var done: (Int) -> () = { _ in }
    
    func getImages(start: Date, end: Date, defaultLocation: CLLocationCoordinate2D, onDone: @escaping (Int) -> ()) {
        photos = []
        done = onDone
        
        fetchPhotosFromDatabase(start: start, end: end)
        
        fetchPhotosFromPhotoroll(start: start, end: end, defaultLocation: defaultLocation)
    }
    
    
    fileprivate func fetchPhotosFromDatabase(start: Date, end: Date) {
        photos = []
        
        let result = db.realm.objects(RLMImageReference.self)
            .filter { imageReference in
                if imageReference.timeStamp >= start,
                    imageReference.timeStamp <= end {
                    return true
                }
                return false
            }
        
        let identifiers: [String] =
            result.map { entry in
                if let image = Caching.cachedImage(id: entry.identifier, width: 150, height: 150) {
                    self.photos.append(
                        IdentifiableImage(id: entry.identifier, image: image,
                                          timeStamp: entry.timeStamp,
                                          latitude: entry.latitude, longitude: entry.longitude))
                    return ""
                } else {
                    return entry.identifier
                }
            }.compactMap { $0 == "" ? nil : $0 }
        
        // FIXME: The fixed width/heigt is a middle course between re-fetching the big image and loading a huge image by default
        UIImage.photoroll(with: identifiers, width: 150, height: 150) { [weak self] id, image, date, latitude, longitude in
            guard let self = self else {
                return
            }
            
            if self.photos.first(where: { $0.id == id }) == nil {
                self.photos.append(IdentifiableImage(id: id, image: image, timeStamp: date, latitude: latitude, longitude: longitude))
            }
        }
    }
    
    fileprivate func fetchPhotosFromPhotoroll(start: Date, end: Date, defaultLocation: CLLocationCoordinate2D) {
        PHPhotoLibrary.requestAuthorization { [weak self] authStatus in
            
            if authStatus == .authorized {
                // Fetch the images between the start and end date
                let fetchOptions = PHFetchOptions()
                
                fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", start as NSDate, end as NSDate)
                var newImages: [String] = []
                let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                do {
                    try db.realm.write {
                        for index in 0..<assets.count {
                            let asset = assets[index]
                            
                            if db.realm.objects(RLMImageReference.self).first(where: { imageReference in
                                imageReference.identifier == asset.localIdentifier
                            }) == nil {
                                let rlmImage = RLMImageReference()
                                rlmImage.identifier = asset.localIdentifier
                                if let date = asset.creationDate {
                                    rlmImage.timeStamp = date
                                } else {
                                    rlmImage.timeStamp = Date.between(date1: start, date2: end)
                                }
                                if let location = asset.location {
                                    rlmImage.latitude = location.coordinate.latitude
                                    rlmImage.longitude = location.coordinate.longitude
                                } else {
                                    rlmImage.latitude = defaultLocation.latitude
                                    rlmImage.longitude = defaultLocation.longitude
                                }
                                db.realm.add(rlmImage)
                                newImages.append(asset.localIdentifier)
                            }
                        }
                    }
                    
                    
                    // TODO: -Delete next call ... only for testing- LEAVE UNTIL I SOLVE THE REAL PROBLEM OF Image Zooming
                    let width = UIScreen.main.bounds.size.width
                    let height = UIScreen.main.bounds.size.height
                    
                    UIImage.photoroll(with: newImages, width: width, height: height ) { id, image, date, latitude, longitude in
                        Caching.saveImageToCache(id: id, image: image, width: width, height: height)
                    }


                    let dispatchgroup = DispatchGroup()
                    dispatchgroup.enter()
                    
                    var imageCount = newImages.count
                    UIImage.photoroll(with: newImages) { [weak self] id, image, date, latitude, longitude in
                        Caching.saveImageToCache(id: id, image: image)

                        guard let self = self else {
                            // FIXME: Check if necessary           dispatchgroup.leave()
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.photos.append(
                                IdentifiableImage(id: id, image: image,
                                                  timeStamp: date, latitude: latitude, longitude: longitude))
                        }
                        imageCount -= 1
                        if imageCount == 0 {
                            self.photos.sort { ($0.timeStamp ?? Date.distantPast) < ($1.timeStamp ?? Date.distantFuture) }
                            dispatchgroup.leave()
                        }
                    }
                    dispatchgroup.notify(queue: .main) {
                        self?.done(newImages.count)
                    }
                } catch {
                    print("Fetch Photos From Photoroll Error \(error.localizedDescription)")
                }
            }
        }
    }
}
