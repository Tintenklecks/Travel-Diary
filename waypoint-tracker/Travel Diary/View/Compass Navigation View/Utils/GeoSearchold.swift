import Contacts
import Foundation
import MapKit
import IBExtensions

//struct Placemark: Identifiable {
//    let id = UUID()
//    var name: String
//    
//    //  Postal Address
//    var street: String
//    var streetNumber: String
//    
//    var city: String // The city name in a postal address.
//    var state: String // The state name in a postal address.
//    var postalCode: String
//    var country: String
//    var isoCountryCode: String
//    
//    var latitude: Double = 0
//    var longitude: Double = 0
//    var distance: Double = 0
//    
//    init(with placemark: CLPlacemark, origin: CLLocationCoordinate2D? = nil) {
//        self.name = placemark.name ?? ""
//        self.street = placemark.thoroughfare ?? ""
//        self.streetNumber = placemark.subThoroughfare ?? ""
//        self.city = placemark.locality ?? ""
//        self.state = placemark.administrativeArea ?? ""
//        self.postalCode = placemark.postalCode ?? ""
//        self.country = placemark.country ?? ""
//        self.isoCountryCode = placemark.isoCountryCode ?? ""
//        self.latitude = placemark.location?.coordinate.latitude ?? 0
//        self.longitude = placemark.location?.coordinate.longitude ?? 0
//        if let origin = origin,
//            let location = placemark.location {
////            let originLocation = CLLocation(latitude: origin.latitude, longitude: origin.longitude)
//            self.distance = location.coordinate.distance(from: origin)
//        }
//    }
//    
//    // MARK: - Computed Values
//    
//    /// Returns an address in the localized format
//    func localizedAddress(seperated by: String = ", ") -> String {
//        var result = ""
//        let address = CNMutablePostalAddress()
//        address.city = city
//        address.country = country
//        address.isoCountryCode = isoCountryCode
//        address.postalCode = postalCode
//        address.state = state
//        address.street = street
//        
//        result = CNPostalAddressFormatter().string(from: address)
//        return result
//    }
//    
//    var location: CLLocation { CLLocation(latitude: latitude, longitude: longitude) }
//}

class GeoSearch {
    static var shared = GeoSearch()
    
    var timer: Timer?
    var searchDelay: TimeInterval = 0.5
    var searchText = ""
    var center = CLLocation() // TODO:
    var localSearch: MKLocalSearch?
    func timedSearch(searchText: String, result: @escaping ([Placemark]) -> Void) {
        timer?.invalidate()
        self.searchText = searchText
        timer = Timer.scheduledTimer(withTimeInterval: searchDelay, repeats: false, block: { [weak self] _ in
            
            guard let self = self else { return }
            
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = self.searchText
            request.region = MKCoordinateRegion(center: self.center.coordinate, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            request.resultTypes = [.address, .pointOfInterest]
            request.pointOfInterestFilter = .includingAll
            
            if let localSearch = self.localSearch,
                localSearch.isSearching {
                self.localSearch?.cancel()
            }
            self.localSearch = MKLocalSearch(request: request)
            
            self.localSearch?.start(completionHandler: { response, _ in
                guard let mapItems: [MKMapItem] = response?.mapItems else {
                    result([])
                    return
                }
                
                let searchResults = mapItems
                    .compactMap {
                        $0.placemark.coordinate.latitude == 0 && $0.placemark.coordinate.longitude == 0 ? nil : Placemark(with: $0.placemark, origin: self.center.coordinate)
                    }
                    
                    .sorted { $0.distance < $1.distance }
                
                result(searchResults)
                
            })
            
        })
    }
}
