import Foundation

//   let wikiData = try? newJSONDecoder().decode(WikiData.self, from: jsonData)
import Foundation


struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: WikiPage]
}

struct Page: Codable, Identifiable {
    let id = UUID()
    let pageid: Int
    let title: String
    let coordinates: [WikiCoordinate]

    let terms: [String: [String]]?
//    let thumbnail: WikiThumbnail?


}





// MARK: - WikiPage
class WikiPage: Codable {
    let pageid: Int
    let title: String
    let coordinates: [WikiCoordinate]
    let thumbnail: WikiThumbnail?
//    let terms: WikiTerms?


    init(pageid: Int, ns: Int, title: String, index: Int, coordinates: [WikiCoordinate], thumbnail: WikiThumbnail, terms: WikiTerms) {
        self.pageid = pageid
        self.title = title
        self.coordinates = coordinates
        self.thumbnail = thumbnail
//        self.terms = terms
    }
}

// MARK: - WikiCoordinate
class WikiCoordinate: Codable {
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

// MARK: - WikiTerms
class WikiTerms: Codable {
    let termsDescription: [String]

    enum CodingKeys: String, CodingKey {
        case termsDescription
    }

    init(termsDescription: [String]) {
        self.termsDescription = termsDescription
    }
}

// MARK: - WikiThumbnail
class WikiThumbnail: Codable {
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
