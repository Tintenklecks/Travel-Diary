//
//  DBRealm+ImportExport.swift
//  Travel Diary
//
//  Created by Ingo Böhme on 27.07.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import CoreLocation
import Foundation
import RealmSwift

// MARK: - IMPORT DATA

/// Import data
extension db {
    static func importJson(fileURL: URL?) -> Bool {
        guard let fileURL = fileURL else {
            return false
        }
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let importDemoData = try decoder.decode(DemoData.self, from: jsonData)

            db.realm.beginWrite()
            for impWaypoint in importDemoData.visits {
                #if targetEnvironment(simulator)
                let visit = RLMVisit(visit: impWaypoint)
//                    if Int.random(in: 0..<10) == 0 {
//                        visit.departure = Date.distantFuture
//                    }
                #else
                let visit = RLMVisit(visit: impWaypoint)
                #endif
                db.realm.add(visit, update: .all)
            }

            print(FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Settings.groupId)?.path ?? "")

            for locationEntry in importDemoData.locationEntries {
                let entry = RLMLocationEntry()
                entry.id = locationEntry.id
                entry.name = locationEntry.name
                entry.isPlacemark = locationEntry.isPlacemark
                entry.latitude = locationEntry.latitude
                entry.longitude = locationEntry.longitude
                entry.source = locationEntry.source
                entry.url = locationEntry.url
                entry.thumbnail = locationEntry.thumbnail
                db.realm.add(entry, update: .all)
            }
            try db.realm.commitWrite()

            for impLocation in importDemoData.locations {
                let location = CLLocation(coordinate:
                    CLLocationCoordinate2D(latitude: impLocation.latitude, longitude: impLocation.longitude),
                                          altitude: impLocation.elevation,
                                          horizontalAccuracy: 0, verticalAccuracy: 0,
                                          timestamp: impLocation.date.iso8601Date)
                RLMLocation.add(location)
            }

            return true

        } catch {
            print(error)
            return false
        }
    }

    static func clearCache() {
        try? db.realm.write {
            
            let imageCache = db.realm.objects(RLMImageReference.self)
            db.realm.delete(imageCache)
        }
    }

    func compactRealm() { //TODO: implement
        let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
        let defaultParentURL = defaultURL.deletingLastPathComponent()
        let compactedURL = defaultParentURL.appendingPathComponent("default-compact.realm")
        do {
            try autoreleasepool {
                let realm = try Realm()
                try realm.writeCopy(toFile: compactedURL)
            }
            try FileManager.default.removeItem(at: defaultURL)
            try FileManager.default.moveItem(at: compactedURL, to: defaultURL)
        } catch {}
    }

    static func importDefault() {
        #if targetEnvironment(simulator)
        if let url = Bundle.main.url(forResource: "demodataSimulator", withExtension: "json") {
            if !importJson(fileURL: url) {
                assertionFailure("Error decoding JSON Data File")
            }
        }
        #endif
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: FileManager.documentsDirectory().path)
            for file in files {
                print(file)
                if file.lowercased().hasPrefix("data"),
                    file.lowercased().hasSuffix(".json") {
                    let url = FileManager.fileURL(name: file)
                    if importJson(fileURL: url) {
                        try? FileManager.default.removeItem(at: url)
                    } else {
                        print("Error decoding file")
                    }
                }
            }
        } catch {}
    }
}

// MARK: - IMPORT DATA

/// Import data

extension db {
    static func backup() {
        let destinationURL = FileManager.documentDirectoryURL.appendingPathComponent("backup", isDirectory: true)
        let jsonString = "{\(RLMVisit.asJSON),\(RLMLocation.asJSON),\(RLMLocationEntry.asJSON)}"
        do {
            if !FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.createDirectory(
                    at: destinationURL,
                    withIntermediateDirectories: true, attributes: nil)
            }
            let fileURL = destinationURL.appendingPathComponent("data\(Date().sortableDate).json", isDirectory: false)
            try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)

        } catch {
            print(error.localizedDescription)
        }
        print(jsonString)
    }
}
