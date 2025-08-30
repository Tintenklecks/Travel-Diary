//

import Combine
import CoreLocation
import Foundation

class WKDiaryEntryViewModel: ObservableObject, Identifiable, Codable, CompassDataProtocoll {
    let id = UUID()
    var isFavorite = false
    
    var arrival: Date
    var departure: Date
    var locationName: String {
        didSet {
            if self.destinationName == "" {
               self.destinationName = locationName
            }
        }
    }
    
    var destinationName: String = ""
    var longitude: Double
    var latitude: Double
    
    var accuracy: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case arrival
        case departure
        case locationName
        case longitude
        case latitude
        case isFavorite
    }
    
    init() {
        self.longitude = 0
        self.latitude = 0
        self.locationName = ""
        self.arrival = Date.distantFuture
        self.departure = Date.distantFuture
        self.isFavorite = false
    }
    
    init(arrival: Date, departure: Date, latitude: Double, longitude: Double, locationName: String, favorite: Bool) {
        self.longitude = longitude
        self.latitude = latitude
        self.locationName = locationName
        self.arrival = arrival
        self.departure = departure
        self.isFavorite = favorite
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
        locationName = try values.decode(String.self, forKey: .locationName)
        arrival = try values.decode(Date.self, forKey: .arrival)
        departure = try values.decode(Date.self, forKey: .departure)
        isFavorite = try values.decode(Bool.self, forKey: .isFavorite)
    }
}

extension WKDiaryEntryViewModel {
    var secondsOfStay: Double {
        if departure == Date.distantFuture {
            return abs(Date().timeIntervalSince(arrival))
            
        } else {
            return abs(departure.timeIntervalSince(arrival))
        }
    }
    
    var daysOfStay: Int {
        var days = Int(secondsOfStay / 86400)
        if departureTime < arrivalTime {
            days += 1
        }
        return days
    }
    
    var arrivalDate: String { arrival.shortDate }
    var arrivalTime: String { arrival.shortTime }
    var departureDate: String { departure == Date.distantFuture ? "" : departure.shortDate }
    var departureTime: String { departure == Date.distantFuture ? "" : departure.shortTime }
    var isSameDay: Bool { arrivalDate == departureDate }
    var isCurrent: Bool { departure == Date.distantFuture }
    
    var dateSpan: String {
        var result = arrivalDate
        if departure.shortDate != arrival.shortDate,
            !arrival.isCurrentDay {
            result = result + "-" + departureDate
        }
        return result
    }
    
    var timeSpan: String {
        "\(arrivalTime)-\(departureTime)"
    }
    
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var currentLocation: CLLocation {
        Settings.lastLocation
    }
    
    var bearing: Double {
        return currentLocation.bearing(to: location)
    }
    
    var distanceFromLocation: Double {
        return location.distance(from: currentLocation)
    }
    
    static func ==(lhs: WKDiaryEntryViewModel, rhs: WKDiaryEntryViewModel) -> Bool {
        guard lhs.arrival == rhs.arrival else { return false }
        guard lhs.departure == rhs.departure else { return false }
        return true
    }
}
