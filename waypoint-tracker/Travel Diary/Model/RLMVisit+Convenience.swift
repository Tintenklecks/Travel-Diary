import Foundation

extension RLMVisit {
    convenience init(visit: DemoRLMVisit) {
        let arrival = visit.arrival.iso8601Date
        let departure = visit.departure.iso8601Date
        
        self.init(headline: visit.headline,
                  text: visit.text,
                  latitude: visit.latitude, longitude: visit.longitude, accuracy: 50,
                  arrival: arrival, departure: departure,
                  favorite: false)
    }
    

}
