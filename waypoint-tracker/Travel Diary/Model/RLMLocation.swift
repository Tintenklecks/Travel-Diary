///  Model for automatic CLLocation tracking

import CoreLocation
import Foundation
import RealmSwift
import UIKit

class RLMLocation: Object {
    @objc dynamic var unixTime: Int = Int(Date().timeIntervalSince1970)
    @objc dynamic var date: Date = Date()
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0

    @objc dynamic var speed: Double = 0 // m/s
    @objc dynamic var elevation: Double = 0 // m
    @objc dynamic var course: Double = 0 // m

    @objc dynamic var secondsFromGMT: Int = 0

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    override static func primaryKey() -> String? {
        return "unixTime"
    }
}

// MARK: - Convert to JSON String

extension RLMLocation {
    var asJSON: String {
        return """
        {
        "unixTime":\(unixTime),
        "date":"\(date.xsdDateTime)",
        "latitude":\(latitude),
        "longitude":\(longitude),
        "speed":\(speed),
        "elevation":\(elevation),
        "course":\(course)
        }
        """
    }

    static var asJSON: String {
        let array = db.realm
            .objects(RLMLocation.self)
            .sorted(byKeyPath: "unixTime", ascending: false)
            .map { $0.asJSON }
        return "\"RLMLocation\":[\(array.joined(separator: ","))]"
    }
}

extension RLMLocation {
    static func add(_ location: CLLocation) {
        do {
            db.realm.beginWrite()
            let locationRecord = RLMLocation()

            locationRecord.date = location.timestamp
            locationRecord.unixTime = Int(location.timestamp.timeIntervalSince1970)
            locationRecord.latitude = location.coordinate.latitude
            locationRecord.longitude = location.coordinate.longitude
            locationRecord.speed = location.speed
            locationRecord.elevation = location.altitude
            locationRecord.course = location.course
            locationRecord.secondsFromGMT = Locale.current.calendar.timeZone.secondsFromGMT()
            db.realm.add(locationRecord, update: .all)
            try db.realm.commitWrite()

        } catch {}
    }

    static func getEntries(from startDate: Date? = nil, to endDate: Date? = nil) -> [RLMLocation] {
        var predicate = NSPredicate(value: true)

        if let startDate = startDate,
            let endDate = endDate {
            let start = Int(startDate.timeIntervalSince1970)
            let end = Int(endDate.timeIntervalSince1970)
            predicate = NSPredicate(format: "unixTime > %d AND unixTime < %d", start, end)
        }

        return getEntries(with: predicate)
    }

    static func getEntries(with predicate: NSPredicate) -> [RLMLocation] {
        return
            Array(
                db.realm.objects(RLMLocation.self)
                    .filter(predicate)
                    .sorted(byKeyPath: "date")
            )
    }
}
