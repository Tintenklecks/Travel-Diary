import Foundation
import CoreLocation

extension RLMLocationEntry {
    static func addEntry(name: String, latitude: Double, longitude: Double, isPlacemark: Bool,
                         source: LocationSource = LocationSource.apple,
                         url: String = "", thumbnail: String = "") -> RLMLocationEntry? {
        do {
            let entry = RLMLocationEntry()
            entry.latitude = latitude
            entry.longitude = longitude
            entry.id = CLLocationCoordinate2D(latitude: entry.latitude, longitude: entry.longitude).locationString
            entry.name = name
            entry.language = Locale.current.languageCode ?? ""
            entry.source = source.rawValue
            entry.thumbnail = thumbnail
            entry.url = url
            
            try db.realm.write {
                db.realm.add(entry, update: .all)
            }
            return entry
        } catch {
            return nil
        }
    }
    
    static func update(location id: String, name: String) {
        do {
            if let entry = db.realm.objects(RLMLocationEntry.self).filter("id = %@", id)
                .filter("language = %@", Locale.current.languageCode ?? "")
                .first {
                try db.realm.write {
                    entry.name = name
                    db.realm.add(entry, update: .all)
                }
            }
            
        } catch {
            print("TLMLocationEntry Update Error: \(error.localizedDescription)")
        }
    }
    
    static func name(for id: String) -> String {
        if let entry = db.realm.objects(RLMLocationEntry.self)
            .filter("language = %@", Locale.current.languageCode ?? "")
            .filter("id = %@", id).first {
            return entry.name
        }
        return ""
    }
    
    static func name(for latitude: Double, longitude: Double) -> String {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let region = CLCircularRegion(center: location.coordinate,
                                      radius: 100,
                                      identifier: "")
        
        let result = db.realm.objects(RLMLocationEntry.self)
            .filter("language = %@", Locale.current.languageCode ?? "")
            .filter {
                region.contains(
                    CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                )
            }
            .sorted { lhs, rhs in
                
                location.distance(from: CLLocation(latitude: lhs.latitude, longitude: lhs.longitude))
                    <
                    location.distance(from: CLLocation(latitude: rhs.latitude, longitude: rhs.longitude))
            }
        
        /// Option 1: Location found in the datrabase
        if let first = result.first {
            return first.name
        }
        return "\(latitude.latitudeString) \(latitude.longitudeString)"
    }
    
    static func getClosestLocationEntry(latitude: Double, longitude: Double, radius: Double = 50, closure: @escaping (RLMLocationEntry) -> ()) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let region = CLCircularRegion(center: location.coordinate,
                                      radius: min(radius, 50),
                                      identifier: "")
        
        let result = db.realm.objects(RLMLocationEntry.self)
            .filter("language = %@", Locale.current.languageCode ?? "")
            .filter {
                region.contains(
                    CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                )
            }
            .sorted { lhs, rhs in
                
                location.distance(from: CLLocation(latitude: lhs.latitude, longitude: lhs.longitude))
                    <
                    location.distance(from: CLLocation(latitude: rhs.latitude, longitude: rhs.longitude))
            }
        
        /// Option 1: Location found in the datrabase
        if let first = result.first {
            closure(first)
            return
        }
        
        RLMLocationEntry.reverseGeoDecode(latitude: latitude, longitude: longitude) { placemark, placemarkDetected in
            
            /// Option 2: Reverse geocode location
            guard let entry = RLMLocationEntry.addEntry(name: placemark.name, latitude: placemark.latitude, longitude: placemark.longitude, isPlacemark: placemarkDetected, source: .apple, url: "", thumbnail: "") else {
                return
            }
            
            if placemarkDetected {
                closure(entry)
                return
            }
            
            /// Option 3: WIKI
            RLMLocationEntry.getClosestWikiLocation(latitude: latitude, longitude: longitude) { entry in
                _ = RLMLocationEntry.addEntry(name: entry.name, latitude: entry.latitude, longitude: entry.longitude, isPlacemark: true)
                
                closure(entry)
                return
            }
        }
    }
    
    /// Option 3: get location name from WIKI
    
    static func getClosestWikiLocation(latitude: Double, longitude: Double, closure: @escaping (RLMLocationEntry) -> ()) {
        let wiki = WikipediaViewModel()
        wiki.closestWikiPage(at: latitude, longitude: longitude) {
            wikiPage in
            
            if wikiPage.distance < 100000 {
                if let entry = RLMLocationEntry.addEntry(name: wikiPage.title,
                                                         latitude: wikiPage.latitude, longitude: wikiPage.longitude,
                                                         isPlacemark: true,
                                                         source: .wikipedia, url: "", thumbnail: wikiPage.thumbnail) {
                    closure(entry)
                }
            }
        }
    }
    
    typealias ReverseGeoDecodeClosure = (_ placeName: RLMLocationEntry, _ placemarkDetected: Bool) -> ()
    
    static func reverseGeoDecode(latitude: Double, longitude: Double, closure: @escaping ReverseGeoDecodeClosure) {
        var result: String = ""
        
        var placemarkDetected: Bool = false
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            
            if let placemark = placemarks?.first {
                if let poi = placemark.areasOfInterest?.first {
                    result = poi
                    placemarkDetected = true
                } else if let locality = placemark.locality {
                    var name = locality
                    if let subLocality = placemark.subLocality,
                        subLocality != name {
                        name += ", " + subLocality
                    } else if let admin = placemark.administrativeArea,
                        admin != name {
                        name += ", " + admin
                    }
                    result = name
                } else if let country = placemark.country {
                    result = country
                } else if let water = placemark.inlandWater {
                    result = water
                } else if let water = placemark.ocean {
                    result = water
                }
                
                if let locationEntry = RLMLocationEntry.addEntry(name: result, latitude: latitude, longitude: longitude, isPlacemark: placemarkDetected, source: .apple) {
                    closure(locationEntry, placemarkDetected)
                }
            }
            
            if !placemarkDetected { // search Google
            }
            
            if !placemarkDetected { // search Wikipedia
                let wiki = WikipediaViewModel()
                wiki.closestWikiPage(at: latitude, longitude: longitude) { wikiPage in
                    
                    if let locationEntry =
                        RLMLocationEntry.addEntry(name: wikiPage.title,
                                                  latitude: wikiPage.latitude,
                                                  longitude: wikiPage.longitude,
                                                  isPlacemark: true,
                                                  source: .wikipedia, url: "",
                                                  thumbnail: wikiPage.thumbnail) {
                        closure(locationEntry, true)
                    }
                }
            }
        }
    }
}
