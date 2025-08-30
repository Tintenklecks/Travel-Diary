import Combine
import CoreLocation
import Foundation
import RealmSwift
import UIKit

class RLMVisit: Object {
    @objc dynamic var id: String = "\(Int(Date().timeIntervalSince1970))" // arrival seconds since 1970

    @objc dynamic var favorite: Bool = false
    @objc dynamic var dateString: String = ""

    @objc dynamic var headline: String = ""
    @objc dynamic var text: String = ""

    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0

    @objc dynamic var accuracy: Double = 50

    @objc dynamic var arrival: Date = Date.distantPast

    @objc dynamic var departure: Date = Date.distantFuture
    @objc dynamic var secondsFromGMT: Int = 0

    override static func primaryKey() -> String? {
        return "id"
    }

    override static func indexedProperties() -> [String] {
        ["arrivalDate"]
    }
}

// MARK: - Convenience init

extension RLMVisit {
    convenience init(headline: String = "", text: String = "", latitude: Double, longitude: Double, accuracy: Double, arrival: Date, departure: Date, favorite: Bool = false) {
        self.init()
        self.id = "\(Int(arrival.timeIntervalSince1970))"

        self.headline = headline
        self.text = text
        self.latitude = latitude
        self.longitude = longitude
        self.accuracy = accuracy
        self.departure = departure
        self.arrival = arrival
        self.dateString = arrival.sortableDate
        self.favorite = favorite
        self.secondsFromGMT = Locale.current.calendar.timeZone.secondsFromGMT()
    }
}

// MARK: - Convert to JSON String

extension RLMVisit: JSONExport {
    var asJSON: String {
        return """
        {
        "id":"\(id.encoded)",
        "headline":"\(headline.encoded)",
        "text":"\(text.encoded)",
        "latitude":\(latitude),
        "longitude":\(longitude),
        "departure":"\(departure.xsdDateTime.encoded)",
        "arrival":"\(arrival.xsdDateTime.encoded)",
        "favorite":\(favorite ? "true" : "false")
        }
        """
    }

    static var asJSON: String {
        let array = db.realm
                .objects(RLMVisit.self)
                .sorted(byKeyPath: "arrival", ascending: false)
                .map { $0.asJSON }
            return "\"RLMVisit\":[\(array.joined(separator: ","))]"
    }
}
