import Foundation
import CoreLocation
 
public extension CLLocation {
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    func bearing(to point : CLLocation) -> Double {

        let lat1 = degreesToRadians(degrees: self.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: self.coordinate.longitude)

        let lat2 = degreesToRadians(degrees: point.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radians: radiansBearing)
    }
    
    static func bearing(from latitude1: Double, longitude1: Double, to  latitude2: Double, longitude2: Double ) -> Double{
        let location = CLLocation(latitude: latitude1, longitude: longitude1)
        let destination = CLLocation(latitude: latitude2, longitude: longitude2)
        return location.bearing(to: destination)
        
    }

}
