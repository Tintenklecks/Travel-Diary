
import Foundation
import CoreLocation

#if os(iOS)
import PhotosUI
#endif


extension Settings {
    static var locationInitialized: Bool {
        if Settings.locationState != .notDetermined {
            return true
        }
        return false
    }
    
    static var lastDestination: (String, CLLocation) {
        get {
            let coordinate = CLLocation(
                latitude: Settings.getDouble("DestinationLatitude", defaultValue: 0),
                longitude: Settings.getDouble("DestinationLongitude", defaultValue: 0))
            let name = Settings.getString("DestinationName", defaultValue: "")
            return (name, coordinate)
        }
        set {
            Settings.setDouble("DestinationLatitude", value: newValue.1.coordinate.latitude)
            Settings.setDouble("DestinationLongitude", value: newValue.1.coordinate.longitude)
            Settings.setString("DestinationName", value: newValue.0)
        }
    }
    
    static var lastLocation: CLLocation {
        get {
            let coordinate = CLLocationCoordinate2D(
                latitude: Settings.getDouble("LastLatitude", defaultValue: 0),
                longitude: Settings.getDouble("LastLongitude", defaultValue: 0))
            let accuracy = Settings.getDouble("LastAccuracy", defaultValue: 50)
            let timeStamp = Date(timeIntervalSince1970: Settings.getDouble("LastLocationDate", defaultValue: 0))
            
            if abs(Date().distance(to: timeStamp)) > 30 { // If saved location is too old ...
                LocationPublisher.shared.updateLocation()
            }
            return CLLocation(coordinate: coordinate, altitude: 0,
                              horizontalAccuracy: accuracy, verticalAccuracy: 0, timestamp: timeStamp)
        }
        set {
            Settings.setDouble("LastLatitude", value: newValue.coordinate.latitude)
            Settings.setDouble("LastLongitude", value: newValue.coordinate.longitude)
            Settings.setDouble("LastAccuracy", value: newValue.horizontalAccuracy)
            Settings.setDouble("LastLocationDate", value: newValue.timestamp.timeIntervalSince1970)
        }
    }
    
    static var locationState: CLAuthorizationStatus {
        get {
            if let state = UserDefaults.standard.object(forKey: "LocationState") as? Int32,
                let authState = CLAuthorizationStatus(rawValue: state) {
                return authState
            } else {
                return CLAuthorizationStatus.notDetermined
            }
        }
        set {
            Settings.setInt("LocationState", value: Int(newValue.rawValue))
        }
    }
    
    #if os(iOS)
    
    /// Photo Role
    
    static var includeImagesAtLocation: Bool {
        get {
            return Settings.getBool("includeImagesAtLocation", defaultValue: false)
        }
        set {
            Settings.setBool("includeImagesAtLocation", value: newValue)
        }
    }
    
    static var photoStatus: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    static var photoAuthRequested: Bool {
        get {
            return Settings.getBool("photoAuthRequested", defaultValue: false)
        }
        set {
            Settings.setBool("photoAuthRequested", value: newValue)
        }
    }
    #endif
    
    static var cellStyle: CellStyle {
        get {
            return CellStyle(rawValue: Settings.getInt("cellStyle", defaultValue: 1)) ?? CellStyle.detailed
        }
        set {
            Settings.setInt("cellStyle", value: newValue.rawValue)
        }
    }
    
}
