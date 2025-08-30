#if os(iOS)
import Foundation
import RealmSwift

extension WKDiaryViewModel {
    static func getNextEntries(start: Int = 0, count: Int = 10) ->  [WKDiaryEntryViewModel] {
        let records = db.realm.objects(RLMVisit.self).sorted(byKeyPath: "arrival", ascending: false)
            .dropFirst(start)
        var entries: [WKDiaryEntryViewModel] = []
        for (index,record) in records.enumerated() {
            if index >= count {
                break
            }
            
            let locationName = RLMLocationEntry.name(
                for: record.latitude, longitude: record.longitude)
            
        let entry = WKDiaryEntryViewModel(
            arrival: record.arrival, departure: record.departure,
            latitude: record.latitude, longitude: record.longitude,
            locationName: locationName, favorite: record.favorite)
            entries.append(entry)

        }
        return entries
        
    }
}

#endif
