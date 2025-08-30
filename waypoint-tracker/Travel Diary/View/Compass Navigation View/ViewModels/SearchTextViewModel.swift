import MapKit
import SwiftUI

class SearchTextViewModel: ObservableObject {
    @Published var searchText = "" {
        didSet {
            if searchText != "" {
                selectedPlacemarkId = ""
            }
            GeoSearch.shared.timedSearch(searchText: searchText) { [weak self] placemarks in
                self?.placemarks = placemarks
            }
        }
    }

    @Published var placemarks: [Placemark] = []

    @Published var pois = MKPointOfInterestCategory.all
    @Published var selectedPlacemarkId = ""


    var longitude: Double = 0
    var latitude: Double = 0
}
