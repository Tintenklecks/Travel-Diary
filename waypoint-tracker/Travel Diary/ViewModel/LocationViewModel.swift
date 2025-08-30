
import SwiftUI
import Combine
import CoreLocation


class LocationViewModel: ObservableObject {
    var date: Date
    var latitude: Double
    var longitude: Double

    var speed: Double
    var elevation: Double
    var course: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(date: Date, latitude: Double, longitude: Double, speed: Double = 0, elevation: Double = 0, course: Double = 0) {
        self.date = date
        self.latitude = latitude
        self.longitude = longitude

        self.speed = speed
        self.elevation = elevation
        self.course = course
    }
    
    static func allEntries(in region: CLCircularRegion) -> [LocationViewModel] {
        RLMLocation.getEntries()
            .filter { entry in
                return region.contains(entry.coordinate)
            }
            .map {
                LocationViewModel(date: $0.date,
                                  latitude: $0.latitude,
                                  longitude: $0.longitude)
            }
    }
    
    

}
