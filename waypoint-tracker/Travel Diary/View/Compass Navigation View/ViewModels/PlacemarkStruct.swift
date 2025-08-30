import Contacts
import Foundation
import MapKit
import IBExtensions

struct Placemark: Identifiable {
    let id = UUID()
    var name: String
    
    //  Postal Address
    var street: String
    var streetNumber: String
    
    var city: String // The city name in a postal address.
    var state: String // The state name in a postal address.
    var postalCode: String
    var country: String
    var isoCountryCode: String
    
    var around: [String] = []
    
    var latitude: Double = 0
    var longitude: Double = 0
    var distance: Double = 0
    
    init(with placemark: CLPlacemark, origin: CLLocationCoordinate2D? = nil) {
        self.name = placemark.name ?? ""
        self.street = placemark.thoroughfare ?? ""
        self.streetNumber = placemark.subThoroughfare ?? ""
        self.city = placemark.locality ?? ""
        self.state = placemark.administrativeArea ?? ""
        self.postalCode = placemark.postalCode ?? ""
        self.country = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
        self.latitude = placemark.location?.coordinate.latitude ?? 0
        self.longitude = placemark.location?.coordinate.longitude ?? 0
        if let origin = origin,
            let location = placemark.location {
            self.distance = location.coordinate.distance(from: origin)
        }
        if let around = placemark.areasOfInterest {
            self.around = around
        }
    }
    
    // MARK: - Computed Values
    
    /// Returns an address in the localized format
    func localizedAddress(seperated by: String = ", ") -> String {
        var result = ""
        if street != "" {
            result = result + "\(street) \(streetNumber)".trimmingCharacters(in: .whitespaces)
        }
        if state != "" {
            result = result + "\(by)\(state)".trimmingCharacters(in: .whitespaces)
        }
        if city != "" {
            result = result + "\(by)\(isoCountryCode) \(postalCode) \(city)".trimmingCharacters(in: .whitespaces)
        }

        return result.trimmingCharacters(in: .whitespaces)
    }
    
    var location: CLLocation { CLLocation(latitude: latitude, longitude: longitude) }
}

