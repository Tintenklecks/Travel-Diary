import CoreLocation

import Foundation

extension db {
    static func deleteAll() {
        do {
            try db.realm.write {
                let visits = db.realm.objects(RLMVisit.self)
                db.realm.delete(visits)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Delete all entries with an invalid arrival date
    static func cleanUp() {
        do {
            try db.realm.write {
                // Step 1: Delete all entries with arrival in distant past and all entries
                // with departure in distant future but the first one
                let unNeeded = db.realm.objects(RLMVisit.self)
                    .sorted(byKeyPath: "arrival", ascending: false)
                    .filter { visit in
                        if visit.arrival.timeIntervalSince1970 < 0 {
                            return true
                        }
                        return false
                    }
                if unNeeded.count > 0 {
                    db.realm.delete(unNeeded)
                }
                                
                // Step 3: Set departure if VISIT didnt do
                
                let openDeparture = db.realm.objects(RLMVisit.self)
                    .filter("departure = %@", Date.distantFuture)
                    .sorted(byKeyPath: "arrival", ascending: true)
                
                for visit in openDeparture {
                    if let nextEntry = db.realm.objects(RLMVisit.self)
                        .sorted(byKeyPath: "arrival", ascending: true)
                        .filter("arrival > %@", visit.arrival)
                        .first {
                        let location1 = CLLocation(latitude: visit.latitude, longitude: visit.longitude)
                        let location2 = CLLocation(latitude: nextEntry.latitude, longitude: nextEntry.longitude)
                        let distance = location1.distance(from: location2)
                        var speed: Double {
                            let factor = 1000.0 / 3600
                            if distance < 1000 {
                                return 5 * factor // by foot
                            } else if distance < 1000000 {
                                return 90 * factor // by car
                            } else {
                                return 800 * factor // by plane
                            }
                        }
                        
                        let seconds: Double = distance / speed + 600 // 600 = 10 min for start and arrival
                        
                        var newDepartureTime = Date(timeInterval: -seconds, since: nextEntry.arrival)
                        if newDepartureTime <= visit.arrival {
                            newDepartureTime = Date.between(date1: visit.arrival, date2: nextEntry.arrival)
                        }
                        
                        visit.departure = newDepartureTime
                        db.realm.add(visit, update: .all)
                    }
                }
            }
            
            AppNotification.sendReloadData()
        } catch {
            print("Cleanup Error \(error.localizedDescription)")
        }
    }
}

// MARK: - Notification on Changes

extension db {
    static let notification = Notification.Name("Realm")
    static var publisher = NotificationCenter.default.publisher(for: notification, object: nil)
    static func realmChanged() {
        AppNotification.sendReloadData()
    }
}
