import Foundation
import RealmSwift
import IBExtensions

class db {
    static let shared = db()
    var _realm: Realm?
    
    static var realm: Realm {
        guard shared._realm != nil else {
            guard let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Settings.groupId) else {
                assertionFailure("NO GROUP!!!!!")
                abort()
            }
            let realmFileURL = groupURL.appendingPathComponent("default.realm")
            if !FileManager.default.fileExists(atPath: realmFileURL.path) {
                let oldVersion = FileManager.documentDirectoryURL.appendingPathComponent("default.realm")
                if FileManager.default.fileExists(atPath: oldVersion.path) {
                    do {
                        try FileManager.default.copyItem(at: oldVersion, to: realmFileURL)
                    } catch {
                        print(error)
                    }
                }
            }
            
            var config = Realm.Configuration(
                fileURL: realmFileURL,
                schemaVersion: 1,  // 18 = 2nd Version App Store 
                migrationBlock: { migration, oldSchemaVersion in
                    // We haven’t migrated anything yet, so oldSchemaVersion == 0
                    if oldSchemaVersion < 13 {
                        migration.enumerateObjects(ofType: RLMVisit.className()) { oldObject, newObject in
                            // combine name fields into a single field
                            let arrival = oldObject!["arrival"] as! Date
                            let dateString = arrival.sortableDate
                            newObject!["dateString"] = dateString
                        }
                    }
            })
            
            Realm.Configuration.defaultConfiguration = config
            
            if let realm = try? Realm() {
                shared._realm = realm
                return realm
            }
            
            // Worst case: Shared container doesnt work

            config.fileURL = FileManager.documentDirectoryURL.appendingPathComponent("default.realm")
          
            Realm.Configuration.defaultConfiguration = config
            
            if let realm = try? Realm() {
                shared._realm = realm
                return realm
            }

            preconditionFailure("REALM error")
        }
        
        // TODO: Thread problem - Return shared.realm!!!!!
        
        return try! Realm()
    }
}
