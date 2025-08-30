
import CoreLocation
import Foundation

class WikiViewModel: ObservableObject {
    @Published var pages: [WikiPageViewModel] = []
    
    private func getURL(language: String = "en", latitude: Double, longitude: Double) -> URL? {
        return URL(
            string: "https://\(language).wikipedia.org/w/api.php?ggscoord=\(latitude)|\(longitude)&action=query&prop=coordinates|pageimages|pageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json".replacingOccurrences(of: "|", with: "%7C")
        )
    }
    
    private func processJsonData(jsonData: Data, currentLocation: CLLocation) {
        do {
        //    print("\n\n\n\(String(data: jsonData, encoding: .utf8) ?? ""))\n\n\n")
            let items = try JSONDecoder().decode(Result.self, from: jsonData)
            let resultArray = Array(items.query.pages.values)
            var placesaround: [WikiPageViewModel] = []
            
            for page in resultArray {
             
                let wikiPage = WikiPageViewModel(
                    id: page.pageid, title: page.title,
                    latitude: page.coordinates.first?.lat ?? 0,
                    longitude: page.coordinates.first?.lon ?? 0,
                    thumbnail: page.thumbnail?.source, terms: []
                )
                
                wikiPage.distance = currentLocation.distance(from: CLLocation(latitude: wikiPage.coordinate.latitude, longitude: wikiPage.coordinate.longitude))
                if placesaround.filter({ page in
                    page == wikiPage
                }).count == 0 {
                    placesaround.append(wikiPage)
                }
            }
            
            DispatchQueue.main.async {
                self.pages = placesaround.sorted { page1, page2 in
                    page1.distance < page2.distance
                }
            }
            
        } catch {
        }
    }
    
    func loadWikiPages(at latitude: Double, longitude: Double, language: String = Locale.current.languageCode ?? "en", result: @escaping ([WikiPageViewModel]) -> () = { _ in }) {
        var languages = ["en"]
        if language != "en" {
            languages.insert(language, at: 0)
        }
        for language in languages {
            if let url = getURL(language: language, latitude: latitude, longitude: longitude) {
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    
                    guard let data = data, data.count > 0 else {
                        if language != "en" { // fallback
                            self.loadWikiPages(at: latitude, longitude: longitude, language: "en", result: result)
                        }
                        return
                    }
                    
                    let sourceLocation = CLLocation(latitude: latitude, longitude: longitude)
                    
                    self.processJsonData(jsonData: data, currentLocation: sourceLocation)
                    
                    result(self.pages)
                }
                task.resume()
            }
        }
    }
    
    func closestWikiPage(at latitude: Double, longitude: Double, result: @escaping (WikiPageViewModel) -> () = { _ in }) {
        self.loadWikiPages(at: latitude, longitude: longitude) { pages in
            guard let closest = pages.first else {
                return
            }
            result(closest)
        }
    }
}
