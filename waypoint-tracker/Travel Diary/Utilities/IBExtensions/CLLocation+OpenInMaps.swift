//
#if os(iOS)
import CoreLocation
import Foundation
import UIKit

public enum MapApplications {
    case apple
    case google
    case waze
    
    var scheme: String {
        switch self {
        case .apple:
            return "http://maps.apple.com/?daddr=%f,%f"
        case .google:
            return "comgooglemaps://?daddr=%f,%f&directionsmode=driving"
        case .waze:
            return "waze://?ll=%f,%f&navigate=false"
        }
    }
    
    func url(latitude: Double, longitude: Double) -> URL {
        let urlString = String(format: self.scheme, latitude, longitude)
        let url = URL(string: urlString)
        return url!
    }
    
    var isInstalled: Bool {
        return UIApplication.shared.canOpenURL(self.url(latitude: 0, longitude: 0))
    }
    
    func open(latitude: Double, longitude: Double) {
        if self.isInstalled {
            UIApplication.shared.open(self.url(latitude: latitude, longitude: longitude), options: [:], completionHandler: nil)
        }
    }
}

public extension CLLocation {
    func openInMaps(mapApplication: MapApplications = .apple) {
        mapApplication.open(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
}
#endif
