
import CoreLocation
import Foundation
import RealmSwift

extension RLMVisit {
    static func createEntriesFromVicinity(status: @escaping (String) -> () = { _ in }, done: @escaping () -> ()) {
        status("Getting your current location")
        LocationPublisher.shared.execute(maximumTime: 1) { location in
            status("Looking for interesting spots around you")
            WikipediaViewModel().fetchData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude,
                                           language: Locale.current.languageCode ?? "en") { wikiRecords in
                
                let range = 0..<min(wikiRecords.count, 20)
                var departure = Date(timeIntervalSinceNow: -7234)
                var arrival = departure - Double.random(in: 3600...15000)
                
                for index in range {
                    let entry = wikiRecords[index]
                    
                    let rlmVisit = RLMVisit(headline: entry.title,
                                            text: entry.title,
                                            latitude: entry.latitude,
                                            longitude: entry.longitude,
                                            accuracy: location.horizontalAccuracy,
                                            arrival: arrival,
                                            departure: departure)
                    rlmVisit.save()
                    
                    departure = arrival - Double.random(in: 3600...15000)
                    arrival = departure - Double.random(in: 3600...15000)
                }
                done()
            }
        }
    }
}

/// Adding / Updating a visit
extension RLMVisit {
    static func add(visit: CLVisit) {
        let rlmVisit = RLMVisit(latitude: visit.coordinate.latitude,
                                longitude: visit.coordinate.longitude,
                                accuracy: visit.horizontalAccuracy,
                                arrival: visit.arrivalDate,
                                departure: visit.departureDate)
        rlmVisit.save()
    }
    
    static func addCurrentPosition() -> RLMVisit {
        let rlmVisit = RLMVisit(text: TXT.savedPosition,
                                latitude: Settings.lastLocation.coordinate.latitude,
                                longitude: Settings.lastLocation.coordinate.longitude,
                                accuracy: Settings.lastLocation.horizontalAccuracy,
                                arrival: Date(timeIntervalSinceNow: -150).roundedToMinute,
                                departure: Date(timeIntervalSinceNow: +150).roundedToMinute)
        rlmVisit.save()
        return rlmVisit
    }
}

// MARK: - Save current object

/// SAVE Visit
extension RLMVisit {
    func save() {
        do {
            db.realm.beginWrite()
            if let entry = db.realm.objects(RLMVisit.self).first(where: { [weak self] visit in
                visit.arrival == self?.arrival
            }) {
                if entry.departure != Date.distantFuture, departure == Date.distantFuture {
                    // Dont update the record as the current deparure is not set
                } else {
                    entry.headline = headline
                    entry.text = text
                    entry.favorite = favorite
                    entry.departure = departure
                    entry.accuracy = accuracy
                    entry.secondsFromGMT = secondsFromGMT
                    db.realm.add(entry, update: .all)
                }
            } else {
                db.realm.add(self, update: .all)
            }
            
            try db.realm.commitWrite()
            
            db.realmChanged()
            
        } catch {
            print("SAVE Visit \(error.localizedDescription)")
        }
    }
}

// MARK: - Delete

/// Delete
extension RLMVisit {
    /// delete current object
    func delete() -> Bool {
        do {
            guard let objectToBeDeleted = db.realm.objects(RLMVisit.self).first(where: { visit -> Bool in
                visit.arrival == self.arrival && visit.departure == self.departure
            }) else {
                return false
            }
            
            try db.realm.write {
                db.realm.delete(objectToBeDeleted)
            }
            
            db.realmChanged()

            return true
            
        } catch {
            print("RLMVisit Delete Error \(error.localizedDescription)")
            return false
        }
    }
    
    static func delete(arrival: Date, departure: Date) {
        do {
            try db.realm.write {
                if let visitEntry = db.realm.objects(RLMVisit.self)
                    .first(where: {
                        visit in
                        arrival == visit.arrival &&
                            departure == visit.departure
                    }) {
                    db.realm.delete(visitEntry)
                }
            }
        } catch {}
    }
}

// MARK: - Querying Visits

/// Querying visits

extension RLMVisit {
    /// getEntry gets a possible result at a date for the current realm
    static func getEntry(on date: Date) -> RLMVisit? {
        let result = db.realm.objects(RLMVisit.self)
            .first(where: { $0.arrival == date })
        return result
    }
    
    static func getEntries(for sortableDateString: String? = nil) -> [RLMVisit] {
        var predicate = NSPredicate(value: true)
        
        if let sortableDateString = sortableDateString {
            predicate = NSPredicate(format: "dateString = %@", sortableDateString)
        }
        
        let entries = db.realm.objects(RLMVisit.self)
            .filter(predicate)
            .sorted(byKeyPath: "arrival", ascending: false)
        
        return Array(entries).map { $0 }
    }
}

// MARK: - Visits in Region

/// Get visits in region
extension RLMVisit {
    static func visits(between topLeft: CLLocationCoordinate2D? = nil, and bottomRight: CLLocationCoordinate2D? = nil) -> [RLMVisit] {
        var result: [RLMVisit] = []
        
        let predicate = NSPredicate(format: "latitude <= %f && longitude >= %f && latitude >= %f && longitude <= %f",
                                    topLeft?.latitude ?? 90,
                                    topLeft?.longitude ?? -180,
                                    bottomRight?.latitude ?? -90,
                                    bottomRight?.longitude ?? 180)
        
        result = db.realm.objects(RLMVisit.self)
            .filter(predicate)
            .compactMap { $0 }
        
        return result
    }
}
