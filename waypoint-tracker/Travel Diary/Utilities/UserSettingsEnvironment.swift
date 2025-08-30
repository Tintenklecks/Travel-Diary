import CoreLocation
import PhotosUI
import SwiftUI
import UIKit

class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var permissionsOK = false
    @Published var showPermissionsDialog = true
    @Published var startAnimationDone = false
    @Published var showPictures = Settings.showPictures {
        didSet {
            Settings.showPictures = showPictures
        }
    }
    
    var permissionLocation = false {
        didSet {
            self.permissionsOK = self.permissionLocation && self.permissionPhotos
            self.showPermissionsDialog = !self.permissionsOK
        }
    }
    
    var permissionPhotos = true {
        didSet {
            self.permissionsOK = self.permissionLocation && self.permissionPhotos
            self.showPermissionsDialog = !self.permissionsOK
        }
    }
    
    func checkPermissions() {
        _ = self.getLocationState()
    }
    
    func getLocationState() -> PermissionState {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            self.permissionLocation = true
            return .agreed
        case .notDetermined:
            self.permissionLocation = false
            return .notYetAgreed
        case .restricted:
            self.permissionLocation = false
            return .activateInSettings
            
        case .denied:
            self.permissionLocation = false
            return .activateInSettings
            
        case .authorizedWhenInUse:
            self.permissionLocation = false
            return .activateInSettings
            
        @unknown default:
            self.permissionLocation = false
            return .activateInSettings
        }
    }
    
    init() {
        self.checkPermissions()
    }
}
