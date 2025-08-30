import Combine
import CoreLocation
import Foundation
import SwiftUI

struct HeadingData {
    let heading: Double
    let accuracy: Double
    var uiColor: UIColor {
        if accuracy > 90 { return UIColor(red: 0.54, green: 0.50, blue: 0.49, alpha: 1)  }
        if accuracy > 45 { return UIColor(red: 0.65, green: 0.49, blue: 0.42,  alpha: 1)  }
        if accuracy > 30 { return UIColor(red: 0.76, green: 0.48, blue: 0.35, alpha: 1)  }
        if accuracy > 20 { return UIColor(red: 0.89, green: 0.47, blue: 0.27, alpha: 1)  }
        if accuracy > 15 { return UIColor(red: 1.00, green: 0.45, blue: 0.23, alpha: 1)  }
        if accuracy > 10 { return UIColor(red: 1.00, green: 0.29, blue: 0.17, alpha: 1) }
        if accuracy > 5 { return UIColor(red: 1.00, green: 0.13, blue: 0.11, alpha: 1)  }
        return UIColor.red
    }
    var color: Color { Color(uiColor) }

}

class LocationPublisher: NSObject, ObservableObject {
    static let shared = LocationPublisher()
    
    let locationManager = CLLocationManager()
    
    private var nextLocationClosure: ((CLLocation) -> ())?
    
    @Published var status: PermissionState = .notYetAgreed
    @Published var statusChanged: Bool = false
    
    #if targetEnvironment(simulator)
    var simulatorHeading = Double.random(in: 0...360)
    #endif
    
    #if os(iOS)
    var visit: (CLVisit) -> () = { _ in }
    #endif
    
    var location: (CLLocation) -> () = { _ in }
    var heading: (Double) -> () = { _ in }
    
    let headingPublisher = PassthroughSubject<HeadingData, Never>()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
}

extension LocationPublisher: CLLocationManagerDelegate {
    func checkState() {
        let newValue = status != PermissionState.agreed
        if statusChanged != newValue {
            statusChanged = newValue
        }
    }
    
    func startHeading() {
        locationManager.startUpdatingHeading()
        
        #if targetEnvironment(simulator)
        
        heading(simulatorHeading)
        let headingData = HeadingData(heading: simulatorHeading, accuracy: 10)
        headingPublisher.send(headingData)
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            self.simulatorHeading = self.simulatorHeading + Double.random(in: -0.2...0.3)
            
            self.heading(self.simulatorHeading)
            let headingData = HeadingData(heading: self.simulatorHeading, accuracy: 0 + Double.random(in: 0...30))
            self.headingPublisher.send(headingData)
        }
        #endif
    }
    
    func updateLocation() {
        locationManager.requestLocation()
    }
    
    /// Delegate methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = PermissionState.from(authState: status)
        checkState()
        
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways:
            #if os(iOS)
            locationManager.startMonitoringVisits()
            locationManager.startMonitoringSignificantLocationChanges()
            #endif
            
            // for iOS and watchOS
            manager.startUpdatingHeading()
        default:
            break
        }
    }
    
    #if os(iOS)
    
    func locationManager(_ locationManager: CLLocationManager, didVisit visit: CLVisit) {
        self.visit(visit)
        db.backup() // export
    }
    
    #endif
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location(location)
            Settings.lastLocation = location
            print("XXX   Current location tracked: \(Settings.lastLocation.coordinate.latitude) \(Settings.lastLocation.coordinate.longitude)")

            
            if let closure = self.nextLocationClosure {
                closure(location)
                nextLocationClosure = nil
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading(newHeading.trueHeading)
        let headingData = HeadingData(heading: newHeading.trueHeading, accuracy: newHeading.headingAccuracy)
        headingPublisher.send(headingData)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}

extension LocationPublisher {
    func execute(maximumTime seconds: TimeInterval? = nil, at nextLocation: @escaping (CLLocation) -> ()) {
        nextLocationClosure = nextLocation
        
        #if targetEnvironment(simulator)
        locationManager.delegate?.locationManager?(locationManager, didUpdateLocations: [Settings.lastLocation])
        #endif
        
        if let seconds = seconds {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.nextLocationClosure = nil
                nextLocation(Settings.lastLocation)
            }
        }
        
        locationManager.requestLocation()
    }
}

enum PermissionState {
    case notYetAgreed
    case activateInSettings
    case agreed
    
    var name: String {
        switch self {
        case .notYetAgreed:
            return TXT.notYetAgreed
        case .activateInSettings:
            return TXT.activateInSettings
        case .agreed:
            return TXT.agreedToAlways
        }
    }
    
    static func from(authState: CLAuthorizationStatus) -> PermissionState {
        switch authState {
        case .notDetermined:
            return .notYetAgreed
        case .restricted,
             .denied,
             .authorizedWhenInUse:
            return .activateInSettings
        case .authorizedAlways:
            return .agreed
        @unknown default:
            return .activateInSettings
        }
    }
}
