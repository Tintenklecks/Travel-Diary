import Foundation

/// WIKI Model File


struct WIKIResult: Codable {
    let query: WIKIQuery
}

struct WIKIQuery: Codable {
    let pages: [Int: WIKIPage]
}



// MARK: - WIKIPage
class WIKIPage: Codable {
    let pageid: Int
    let title: String
    let coordinates: [WIKICoordinate]
    let thumbnail: WIKIThumbnail?
//    let terms: WIKITerms?


    init(pageid: Int, ns: Int, title: String, index: Int, coordinates: [WIKICoordinate], thumbnail: WIKIThumbnail, terms: WIKITerms) {
        self.pageid = pageid
        self.title = title
        self.coordinates = coordinates
        self.thumbnail = thumbnail
//        self.terms = terms
    }
}

// MARK: - WIKICoordinate
class WIKICoordinate: Codable {
    let lat: Double
    let lon: Double
    let primary: String
    let globe: String

    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case primary
        case globe
    }

    init(lat: Double, lon: Double, primary: String, globe: String) {
        self.lat = lat
        self.lon = lon
        self.primary = primary
        self.globe = globe
    }
}

// MARK: - WIKITerms
class WIKITerms: Codable {
    let termsDescription: [String]

    enum CodingKeys: String, CodingKey {
        case termsDescription
    }

    init(termsDescription: [String]) {
        self.termsDescription = termsDescription
    }
}

// MARK: - WIKIThumbnail
class WIKIThumbnail: Codable {
    let source: String
    let width: Int
    let height: Int

    enum CodingKeys: String, CodingKey {
        case source
        case width
        case height
    }

    init(source: String, width: Int, height: Int) {
        self.source = source
        self.width = width
        self.height = height
    }
}
