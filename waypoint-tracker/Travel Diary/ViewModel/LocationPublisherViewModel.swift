import Combine
import CoreLocation
import Foundation
import SwiftUI

/// Don´t forget to add the key **NSLocationWhenInUseUsageDescription** in
/// the info.plist file with a description. Else it doesn´t work at all

/// **LocationPublisherViewModel** ist a ViewModel for a Standard LocationManager
/// which delivers the coordinate of the location and the heading over time.
/// It can be easily enhanced

class LocationPublisherViewModel: NSObject, ObservableObject {
    private let manager: CLLocationManager = CLLocationManager()

    @Published var status: CLAuthorizationStatus = .notDetermined
    @Published var needPermission: Bool = false // status if the app can and needs to request permission 
    @Published var needChangeSettings: Bool = false // status if the status has to be changed in the system´s privacy settings

    @Published var heading: Double = 0
    @Published var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    let locationPublisher = PassthroughSubject<CLLocationCoordinate2D, Never>()
    let headingPublisher = PassthroughSubject<Double, Never>()

    override init() {
        super.init()

        manager.delegate = self
    }
}

extension LocationPublisherViewModel {
    func requestAuthorisation() {
        manager.requestWhenInUseAuthorization()
    }

    func switchToSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            })
        }

    }
    
    

    func startServices() {
        manager.startUpdatingHeading()
        manager.startUpdatingLocation()
    }
    

}

extension LocationPublisherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        var needPermission = false
        var needChangeSettings = false

        switch status {
        case .notDetermined:
            needPermission = true
        case .restricted:
            needChangeSettings = true
        case .denied:
            needChangeSettings = true
        case .authorizedAlways:
            manager.startUpdatingHeading()
            startServices()

        case .authorizedWhenInUse:
            startServices()
        @unknown default:
            break
        }
        self.needPermission = needPermission
        self.needChangeSettings = needChangeSettings
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.magneticHeading
        headingPublisher.send(heading)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coordinate = locations.first?.coordinate ?? coordinate
        locationPublisher.send(coordinate)
    }
}

extension CLAuthorizationStatus {
    var description: String {
        switch self {
        case .notDetermined:
            return "The authorization has not yet been given"
        case .restricted:
            return "The location data usage is restricted"
        case .denied:
            return "The app is not authorized to use location data"

        case .authorizedAlways:
            return "Authorized, when app is in back- or in foreground"
        case .authorizedWhenInUse:
            return "Authorized, when app is in foreground"
        @unknown default:
            return "unknown state"
        }
    }
}
