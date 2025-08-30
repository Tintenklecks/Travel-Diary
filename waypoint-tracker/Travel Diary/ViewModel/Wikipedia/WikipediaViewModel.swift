import Foundation
import CoreLocation


class WIKIViewModel: ObservableObject {
    @Published var pages: [WIKIEntry] = []
    private var location: CLLocation = CLLocation()
    init() {
        pages = []
    }

    func setLocation(latitude: Double, longitude: Double) {
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        pages = []
        WIKIService().fetchAPIData(at: latitude, longitude: longitude) { model in

            if let model = model {
                let pages = model.query.pages
                for (id, page) in pages {
                    let entryLocation = CLLocation(latitude: page.coordinates.first?.lat ?? 0, longitude: page.coordinates.first?.lon ?? 0)
                    
                    let viewModelEntry = WIKIEntry(
                        id: "\(id)",
                        name: page.title,
                        latitude: entryLocation.coordinate.latitude,
                        longitude: entryLocation.coordinate.longitude,
                        distance: entryLocation.distance(from: self.location),
                        thumbnail: page.thumbnail?.source ?? "")
                    print("THUMB: \(page.thumbnail?.source ?? "")")
                    DispatchQueue.main.async {
                        self.pages.append(viewModelEntry)
                    }
                }
            }
        }
    }
}

struct WIKIEntry: Identifiable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let distance: Double
    let thumbnail: String
}
