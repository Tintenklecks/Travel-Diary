/// # This is the WikipediaService
/// The demo retrieves the data from the ratesapi.io REST service and decodes it to the WikipediaModel model
import Combine
import Foundation

/// WikipediaError is the enum in which the error is passed back from the DataTask Publisher
enum WikipediaError: Error {
    case none, unknown
    case api(description: String)
    case decoding(description: String)
    case network(description: String)

    var description: String {
        switch self {
        case .none:
            return ""
        case .unknown:
            return "unknown"
        case .api(description: let description):
            return "API Error: \(description)"
        case .decoding(description: let description):
            return "Decoding Error: \(description)"
        case .network(description: let description):
            return "Network Error: \(description)"
        }
    }
}

enum WikipediaServiceState {
    case idle
    case loading
    case loaded
    case error
}

class WikipediaService {
    // Parameter of the call
    var language: String
    var latitude: Double
    var longitude: Double
    
    init() {
         language = Locale.current.languageCode ?? "en"
         latitude = 0
         longitude = 0

    }

    var url: String {
        return "https://\(language).wikipedia.org/w/api.php?ggscoord=\(latitude)|\(longitude)&action=query&prop=coordinates|pageimages|pageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json".replacingOccurrences(of: "|", with: "%7C")
    }

    /// In the example call, the first parameter is the one, the datatask is called with and the result  **<String:Double>** is what the subscriber gets when calling the **fetchAPIData**
    func fetchAPIData() -> AnyPublisher<[Int: WikipediaPage], WikipediaError> {

        guard let url = URL(string: self.url) else {
            fatalError("URL invalid")
        }
        
        let request = URLRequest(url: url)

        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw WikipediaError.unknown
                }
                guard httpResponse.statusCode == 200 else {
                    throw WikipediaError.network(description: "Something wrong on line (Code: \(httpResponse.statusCode)")
                }

                guard httpResponse.statusCode == 200 else {
                    if let error = try? JSONDecoder().decode(WikipediaErrorModel.self, from: data) {
                        throw WikipediaError.api(description: error.error.info)
                    } else {
                        throw WikipediaError.network(description: "Something wrong on line (Code: \(httpResponse.statusCode)")
                    }
                }

                return data
            }
            .decode(type: WikipediaModel.self, decoder: JSONDecoder())
            .mapError { error in
                print("WikiMappingError \(error.localizedDescription)")

                return WikipediaError.decoding(description: "Mapping Error: \(error.localizedDescription)")
            }
            .map {
                $0.query?.pages ?? [:]
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

extension WikipediaService {
    /// method to create a parameter for the Wikipedia request. In this case the last path component needs to
    /// be **latest** for the current date or a date in the form **Y-M-d** (ie *2020-1-31*)
    func formattedDate(_ date: Date?) -> String {
        guard let date = date else {
            return "latest"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "y-M-d"
        return formatter.string(from: date)
    }
}
