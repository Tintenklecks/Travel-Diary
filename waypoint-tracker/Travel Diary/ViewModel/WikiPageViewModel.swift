import Foundation
import CoreLocation

class WikiPageViewModel: Identifiable {
    let id: Int
    let title: String
    let coordinate: CLLocationCoordinate2D
    var distance: Double = 0
    let thumbnail: URL?
    //    let terms: String
    
    init(id: Int, title: String, latitude: Double, longitude: Double, thumbnail: String?, terms: [String]) {
        self.id = id
        self.title = title
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.thumbnail = nil
        if terms.count > 0 {
            print(terms)
        }
        //        self.terms = ""
    }
    
    init(page: WikiPage) {
        self.id = page.pageid
        self.title = page.title
        
        if let thumbnail = page.thumbnail?.source {
            self.thumbnail = URL(string: thumbnail)
        } else {
            self.thumbnail = nil
        }
        
        //        if let terms = page.terms {
        //            self.terms = terms.termsDescription.joined(separator: "\n")
        //        } else {
        //            self.terms = ""
        //        }
        if let wikiCoordinate = page.coordinates.first {
            self.coordinate = CLLocationCoordinate2D(latitude: wikiCoordinate.lat, longitude: wikiCoordinate.lon)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }
    
    static func ==(lhs: WikiPageViewModel, rhs: WikiPageViewModel) -> Bool {
        if lhs.coordinate.longitude == rhs.coordinate.longitude  { return true }
        if lhs.coordinate.latitude == rhs.coordinate.latitude  { return true }
        return false
    }

}
