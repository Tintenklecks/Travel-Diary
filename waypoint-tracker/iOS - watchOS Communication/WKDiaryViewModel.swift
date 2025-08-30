//

import Combine
import CoreLocation
import Foundation

enum RequestState {
    case idle
    case loading
    case loaded
    case error
}

class WKDiaryViewModel: ObservableObject {
    static let shared = WKDiaryViewModel()

    @Published var state: RequestState = .idle

    var entries: [WKDiaryEntryViewModel] = []
    var allLoaded = false

    var start: Int {
        return self.entries.count
    }

    var errorMessage: String = ""
}

extension WKDiaryViewModel {
    #if os(watchOS)

    func getNextEntries(count: Int = 10) {
        if self.allLoaded {
            return
        }
        DispatchQueue.main.async {
            self.state = .loading
        }

        self.errorMessage = ""
        WatchManager.shared.getEntries(
            from: self.start, count: count,
            onSuccess: { receivedEntries in
                DispatchQueue.main.async {
                    self.allLoaded = receivedEntries.count == 0
                    self.entries.append(contentsOf: receivedEntries)
                    self.state = .loaded
                    self.objectWillChange.send()
                }
        }) { error in
            DispatchQueue.main.async {
                self.state = .error
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func loadDemoEntries() -> WKDiaryViewModel {
        self.state = .loading
        guard let url = Bundle.main.url(forResource: "demodataSimulator", withExtension: "json") else {
            self.state = .error
            self.errorMessage = "Demo Data not found"
            return self
        }

        guard let data = try? Data(contentsOf: url) else {
            self.state = .error
            self.errorMessage = "Error reading Demodata"
            return self
        }
        guard let wkDemoData = try? JSONDecoder().decode(WKDemoData.self, from: data) else {
            self.state = .error
            self.errorMessage = "Error while decoding Demo data"
            return self
        }

        self.entries = wkDemoData.visits.map { d in
            WKDiaryEntryViewModel(arrival: d.arrival.iso8601Date, departure: d.departure.iso8601Date, latitude: d.latitude, longitude: d.longitude, locationName: d.headline, favorite: false)
        }
        self.state = .loaded
        return self
    }

    func reload() {
        self.entries = []
        self.allLoaded = false
        self.getNextEntries()
    }
    #endif
}

struct WKDemoData: Codable {
    let visits: [WKDemoVisit]

    enum CodingKeys: String, CodingKey {
        case visits = "RLMVisit"
    }
}

// MARK: - RLMVisit

struct WKDemoVisit: Codable {
    let headline, text: String
    let latitude, longitude: Double
    let arrival, departure: String
}
