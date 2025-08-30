/// This is the model file of the Wikipedia Service Request

import Foundation

/// Wikipedia Model File


struct WikipediaModel: Codable {
    let batchcomplete: String
    let query: WikipediaQuery?
}

struct WikipediaQuery: Codable {
    let pages: [Int: WikipediaPage]
}



// MARK: - WikipediaPage
struct WikipediaPage: Codable {
    let pageid: Int
    let title: String
    let coordinates: [WikipediaCoordinate]
    let thumbnail: WikipediaThumbnail?
  //  let terms: WikipediaTerms?


}

// MARK: - WikipediaCoordinate
struct WikipediaCoordinate: Codable {
    let lat: Double
    let lon: Double
}

// MARK: - WikipediaTerms
struct WikipediaTerms: Codable {
    let description: [String]
}

// MARK: - WikipediaThumbnail
struct WikipediaThumbnail: Codable {
    let source: String
    let width: Int
    let height: Int
}


// MARK: - WikipediaErrorModel
struct WikipediaErrorModel: Codable {
    let error: WikipediaErrorInfo
    let servedby: String
}

// MARK: - WikipediaError
struct WikipediaErrorInfo: Codable {
    let code, info, empty: String

    enum CodingKeys: String, CodingKey {
        case code, info
        case empty
    }
}

