//

import CoreLocation
import Foundation
import UIKit

public extension CLLocationCoordinate2D {
    func shift(by delta: CGPoint) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude + Double(delta.y),
            longitude: longitude + Double(delta.x))
    }

    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        CLLocation(latitude: self.latitude, longitude: self.longitude)
            .distance(from: CLLocation(latitude: coordinate.latitude,
                                       longitude: coordinate.longitude))
    }

    static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        guard lhs.latitude == rhs.latitude else { return false }
        guard lhs.longitude == rhs.longitude else { return false }
        return true
    }
}

@available(watchOS 6.2, *)
public extension CLLocation {
    func shift(by delta: CGPoint) -> CLLocation {
        let newCoordinate = coordinate.shift(by: delta)
        if #available(iOS 13.4, *) {
            return CLLocation(coordinate: newCoordinate, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, course: course, courseAccuracy: courseAccuracy, speed: speed, speedAccuracy: speedAccuracy, timestamp: timestamp)
        } else {
            return CLLocation(coordinate: newCoordinate, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, timestamp: timestamp)
        }
    }
}
