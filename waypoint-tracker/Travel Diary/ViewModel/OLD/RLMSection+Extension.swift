//
//  RLMSection+Extension.swift
//  Travel Diary
//
//  Created by Ingo Böhme on 27.07.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import Foundation
extension RLMSection {
    func getEntries() -> [RLMVisit] {
        return Array(visits.sorted(byKeyPath: "arrival", ascending: false))
    }
    
    static func getSection(for dateString: String) -> RLMSection? {
        return db.realm.objects(RLMSection.self)
            .filter("dateString = %@", dateString).first
    }

    static func getSections() -> [RLMSection] {
        return Array(db.realm.objects(RLMSection.self)
            .sorted(byKeyPath: "dateString", ascending: false)
        )
    }
    
}
