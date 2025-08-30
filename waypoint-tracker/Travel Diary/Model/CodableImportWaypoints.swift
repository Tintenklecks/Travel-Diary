//

import Foundation

// MARK: - ImportWaypoint

// MARK: - DemoData

struct DemoData: Codable {
    let locationEntries: [DemoRLMLocationEntry]
    let locations: [DemoRLMLocation]
    let visits: [DemoRLMVisit]

    enum CodingKeys: String, CodingKey {
        case locations = "RLMLocation"
        case locationEntries = "RLMLocationEntry"
        case visits = "RLMVisit"
    }
}

// MARK: - DemoRLMLocationEntries

struct DemoRLMLocationEntry: Codable {
    let id: String
    let name: String
    let isPlacemark: Bool
    let latitude: Double
    let longitude: Double
    let source: Int
    let url: String
    let thumbnail: String
}

// MARK: - DemoRLMLocation

struct DemoRLMLocation: Codable {
    let unixTime: Int
    let date: String
    let latitude, longitude: Double
    let speed: Double
    let elevation: Double
    let course: Double
    
}

// MARK: - DemoRLMVisit

struct DemoRLMVisit: Codable {
    let id, headline, text: String
    let latitude, longitude: Double
    let arrival, departure: String
    let favorite: Bool
}
