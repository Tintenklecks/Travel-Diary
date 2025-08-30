import Combine
import CoreLocation
import Foundation
import MapKit
import SwiftUI

enum ViewModelState {
    case idle
    case loading
    case loaded
//    case ready
}

class DiaryViewModel: ObservableObject {
    @Published var sections = DiarySectionsViewModel() // Array of sortable Dates String YYYY-MM-DD
    @Published var status: ViewModelState = .idle
    
    static func allEntries(in region: MKMapRect) -> [DiaryEntryViewModel] {
        return RLMVisit.getEntries()
            .filter { entry in
                let location = MKMapPoint(CLLocationCoordinate2D(latitude: entry.latitude, longitude: entry.longitude))
                return region.contains(location)
            }
            .map {
                DiaryEntryViewModel.from(model: $0)
            }
    }
    
    func update(entry: DiaryEntryViewModel) {
        let model = entry.model()
        model.save()
    }
    
    func add(headline: String = "", text: String = "", latitude: Double, longitude: Double, accuracy: Double, arrival: Date, departure: Date) {
        guard arrival != Date.distantPast else {
            return
        }
        
        let visit = DiaryEntryViewModel(headline: headline, text: text,
                                        arrival: arrival.roundedToMinute, departure: departure.roundedToMinute,
                                        latitude: latitude, longitude: longitude,
                                        accuracy: accuracy, locationEntryId: "", favorite: false)
        visit.save()
        
        if departure == Date.distantFuture {
            db.cleanUp()
        }
        objectWillChange.send()
        AppNotification.sendReloadData()
    }
    
    func add(visit: CLVisit) {
        add(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude, accuracy: visit.horizontalAccuracy, arrival: visit.arrivalDate, departure: visit.departureDate)
    }
    
    @discardableResult
    static func addCurrentPosition() -> DiaryEntryViewModel {
        let rlmVisit = RLMVisit.addCurrentPosition()
        AppNotification.sendReloadData()
        return DiaryEntryViewModel.from(model: rlmVisit)
    }
    
//    func loadDatabaseSections() {
//        DispatchQueue.main.async {
//            self.status = .loading
//            self.sections = RLMSection.getSections()
//                .map {
//                    let section = DiarySectionViewModel(sortableDateString: $0.dateString)
//                    section.count = $0.visits.count
//                    return section
//                }
//            self.status = .loaded
//        }
//    }
}
