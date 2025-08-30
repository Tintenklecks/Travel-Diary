import Contacts
import Foundation
import IBExtensions
import MapKit

enum GeoSearchState {
    case none
    case loading
    case loaded
    case noResults
    case error
    
    var text: String {
        switch self {
            
        case .none:
            return TXT.offline
        case .noResults:
            return TXT.noResults
        case .loading:
            return TXT.loading
        case .loaded:
            return TXT.loaded
        case .error:
            return TXT.error
        }
    }
}

class GeoSearch: ObservableObject {
    static var shared = GeoSearch()
    
    @Published var state = GeoSearchState.none
    var timer: Timer?
    var searchDelay: TimeInterval = 0.5
    var searchText = ""
    var center = CLLocation() // TODO:
    var localSearch: MKLocalSearch?
    
    func timedSearch(searchText: String, pois: [MKPointOfInterestCategory] = [], force: Bool = false, result: @escaping ([Placemark]) -> Void) {
        timer?.invalidate()
        self.searchText = searchText
        timer = Timer.scheduledTimer(withTimeInterval: force ? 0 : searchDelay, repeats: false, block: { [weak self] _ in
            
            
            guard let self = self else { return }


            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = self.searchText
            request.region = MKCoordinateRegion(center: self.center.coordinate, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            request.resultTypes = [.address, .pointOfInterest]
                request.pointOfInterestFilter = pois == [] ? .includingAll : MKPointOfInterestFilter(including: pois)

            if let localSearch = self.localSearch,
                localSearch.isSearching {
                
                self.localSearch?.cancel()
            }
            self.localSearch = MKLocalSearch(request: request)

            self.state = .loading

            self.localSearch?.start(completionHandler: { response, _ in
                guard let mapItems: [MKMapItem] = response?.mapItems else {
                    self.state = .noResults

                    result([])
                    return
                }
                var searchResults = mapItems.map { Placemark(with: $0.placemark, origin: Settings.lastLocation.coordinate) }
                
                searchResults.removeAll { placemark -> Bool in
                    placemark.latitude == 0 && placemark.longitude == 0
                }
                
                searchResults.sort { $0.distance < $1.distance }
                
                self.state = searchResults.count == 0 ? .noResults : .loaded
                result(searchResults)
                
            })
            
        })
    }
}
