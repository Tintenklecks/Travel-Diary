import CoreLocation
import SwiftUI

protocol CompassDataProtocoll {
    var destinationName: String { get set }
    var longitude: Double { get set }
    var latitude: Double { get set }
    var accuracy: Double { get set }
    
    var distanceFromLocation: Double { get }
    var bearing: Double { get }
}

class CompassViewModel: ObservableObject, CompassDataProtocoll {
    @Published var latitude: Double = Settings.lastLocation.coordinate.latitude
    @Published var longitude: Double = Settings.lastLocation.coordinate.longitude
    
    var destinationName: String = ""
    var accuracy: Double = 50
    
    init() {}
    
    init(destinationName: String, latitude: Double, longitude: Double, accuracy: Double = 50) {
        self.destinationName = destinationName
        self.longitude = longitude
        self.latitude = latitude
        self.accuracy = accuracy
    }
    
    init(destinationName: String, location: CLLocation) {
        self.destinationName = destinationName
        self.longitude = location.coordinate.longitude
        self.latitude = location.coordinate.latitude
        self.accuracy = 0
    }
    
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var distanceFromLocation: Double {
        Settings.lastLocation.distance(from: CLLocation(latitude: latitude, longitude: longitude))
    }
    
    var bearing: Double {
        return Settings.lastLocation
            .bearing(to:
                CLLocation(latitude: latitude, longitude: longitude))
    }
}
