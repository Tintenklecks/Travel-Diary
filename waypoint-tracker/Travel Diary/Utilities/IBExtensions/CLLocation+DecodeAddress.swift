import CoreLocation
import Foundation

public extension CLLocation {
    var locationString: String {
        return self.coordinate.locationString
    }
}

public extension CLLocationCoordinate2D {
    var locationString: String {
        return "\(self.latitude.latitudeString)\(self.longitude.longitudeString)"
    }
    
}

