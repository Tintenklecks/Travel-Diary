import Combine
import CoreLocation
import Foundation
import SwiftUI

typealias WikipediaResultClosure = ([WikipediaRecord]) -> ()

class WikipediaViewModel: ObservableObject {
    var latitude: Double = 47.2897
    var longitude: Double = 7.9458
    var language: String = "en"

    @Published var pages: [WikipediaRecord] = []

    // @ObservedObject var networkStatus = NetworkStatusViewModel()

    @Published var state: WikipediaServiceState = .idle
    @Published var errorMessage: String = ""

    var subscriber: AnyCancellable?

    func loadWikiPages(at latitude: Double, longitude: Double, in language: String = Locale.current.languageCode ?? "en", result: @escaping WikipediaResultClosure = { _ in }) {
        self.latitude = latitude
        self.longitude = longitude
        self.language = language
        fetchData(latitude: latitude, longitude: longitude, language: language) {
            wikiPages in
            result(wikiPages)
        }
    }

    func fetchData(latitude: Double? = nil,
                   longitude: Double? = nil,
                   language: String = Locale.current.languageCode ?? "en",
                   result: WikipediaResultClosure? = nil) {
        let searchLocation = CLLocation(latitude: latitude ?? self.latitude, longitude: longitude ?? self.longitude)
        state = .loading
        let service = WikipediaService()
        service.latitude = searchLocation.coordinate.latitude
        service.longitude = searchLocation.coordinate.longitude
        service.language = language

        subscriber = service.fetchAPIData()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.errorMessage = ""
                    case .failure(let error):
                        self?.state = .error
                        self?.errorMessage = error.description

                    }
                },
                receiveValue: { data in
                    self.pages = data.map {
                        let page = $0.value
                        let location = CLLocation(latitude: page.coordinates.first?.lat ?? 0,
                                                  longitude: page.coordinates.first?.lon ?? 0)
                        return WikipediaRecord(id: page.pageid,
                                               title: page.title,
                                               latitude: location.coordinate.latitude,
                                               longitude: location.coordinate.longitude,
                                               distance: location.distance(from: searchLocation), thumbnail: page.thumbnail?.source ?? "")
                    }
                    .sorted { model1, model2 in
                        model1.distance < model2.distance
                    }
                    self.state = .loaded
                    if let result = result {
                        result(self.pages)
                    }
                }
            )
    }
}

extension WikipediaViewModel {
    func closestWikiPage(at latitude: Double, longitude: Double, result: @escaping (WikipediaRecord) -> () = { _ in }) {
        loadWikiPages(at: latitude, longitude: longitude) { pages in
            guard let closest = pages.first else {
                return
            }
            result(closest)
        }
    }
}

extension WikipediaViewModel: Equatable {
    static func == (lhs: WikipediaViewModel, rhs: WikipediaViewModel) -> Bool {
//        return lhs.id == rhs.id
        return true
    }
}

// MARK: - other viewmodel related classes and structs

struct WikipediaRecord: Identifiable {
    let id: Int
    let title: String
    let latitude: Double
    let longitude: Double
    let distance: Double
    let thumbnail: String
}
