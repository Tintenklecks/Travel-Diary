import Combine
import CoreLocation
import Foundation
import IBExtensions
import SwiftUI

import RealmSwift

class DiaryEntryViewModel: ObservableObject, Identifiable, CompassDataProtocoll {
    @Published var isFavorite = false
    
    var updateData: () -> Void = {}
    
    var headline = ""
    var text = ""
    var arrival: Date
    var departure: Date
    
    var locationId: String = ""
    
    var locationName: String {
        let name = Location.locationName(for: locationId)
        if destinationName == "" {
            destinationName = name
        }
        return name
    }
    
    var photos: PhotoViewModel = PhotoViewModel()
    
    var imageCount: Int {
        return photos.photos.count
    }
    
    var destinationName: String = ""
    var longitude: Double
    var latitude: Double
    var accuracy: Double = 50
    
    var nextArrival: Date = Date.distantPast
    var nextLongitude: Double = 0
    var nextLatitude: Double = 0
    
    var secondsOnTheRoad: Double {
        if nextArrival > Date.distantPast {
            return nextArrival.timeIntervalSince(departure)
        }
        return 0
    }
    
    var secondsOfStay: Double {
        if departure == Date.distantFuture {
            return abs(Date().timeIntervalSince(arrival))
            
        } else {
            return abs(departure.timeIntervalSince(arrival))
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var currentLocation: CLLocation {
        Settings.lastLocation
    }
    
    var distanceFromLocation: Double {
        return location.distance(from: currentLocation)
    }
    
    var bearing: Double {
        return currentLocation.bearing(to: location)
    }
    
    var daysOfStay: Int {
        var days = Int(secondsOfStay / 86400)
        if departureTime < arrivalTime {
            days += 1
        }
        return days
    }
    
//    let updatedImages = PassthroughSubject<[UIImage], Never>()
    
    var arrivalDate: String { arrival.shortDate }
    var arrivalTime: String { arrival.shortTime }
    var departureDate: String { departure == Date.distantFuture ? "" : departure.shortDate }
    var departureTime: String { departure == Date.distantFuture ? "" : departure.shortTime }
    var isSameDay: Bool { arrivalDate == departureDate }
    var isCurrent: Bool { departure == Date.distantFuture }
    
    init() {
        self.headline = ""
        self.longitude = 0
        self.latitude = 0
        self.arrival = Date.distantFuture
        self.departure = Date.distantFuture
        self.isFavorite = false
    }
    
    init(headline: String = "", text: String = "", arrival: Date, departure: Date, latitude: Double, longitude: Double, accuracy: Double, locationEntryId: String = "", favorite: Bool) {
        self.text = text
        self.longitude = longitude
        self.latitude = latitude
        
        self.accuracy = accuracy
        
        self.arrival = arrival
        self.departure = departure
        
        self.headline = headline
        
        self.isFavorite = favorite
        
        RLMLocationEntry.getClosestLocationEntry(latitude: latitude, longitude: longitude, radius: accuracy + 20) { [weak self] entry in
            self?.locationId = entry.id
            self?.updateData()
        }
        
        #if targetEnvironment(simulator)
        let startDate = Date.distantPast
        let endDate = Date.distantFuture
        
        if self.headline == "" {
            self.headline = TXT.demoHeadlineScreenshots
            self.text = TXT.demoTextScreenshots
        }
        #else
        let startDate = arrival
        let endDate = departure
        #endif
        
        photos.getImages(start: startDate, end: endDate,
                         defaultLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) { [weak self] _ in
            self?.updateData()
        }
    }
    
    static func from(model: RLMVisit) -> DiaryEntryViewModel {
        let entry = DiaryEntryViewModel(
            headline: model.headline, text: model.text,
            arrival: model.arrival, departure: model.departure,
            latitude: model.latitude, longitude: model.longitude, accuracy: model.accuracy,
            favorite: model.favorite)
        return entry
    }
    
    func model() -> RLMVisit {
        let diaryEntry = RLMVisit(headline: headline, text: text, latitude: latitude, longitude: longitude, accuracy: accuracy, arrival: arrival, departure: departure, favorite: isFavorite)
        return diaryEntry
    }
    
    func save() {
        let model = self.model()
        model.save()
    }
    
    func delete() -> Bool{
        let model = self.model()
        return model.delete()
    }
    
    func openInMaps() {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        location.openInMaps()
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        save()
    }
    
    static func entries(for selectedDate: String) -> [DiaryEntryViewModel] {
        RLMVisit.getEntries(for: selectedDate).map { DiaryEntryViewModel.from(model: $0) }
    }
    
    static var allSections: [VisitsSection] {
        RLMVisit.allSections
    }
    
    
}
