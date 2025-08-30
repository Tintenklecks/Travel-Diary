//
//  RLMVisit+Sections.swift
//  Travel Diary
//
//  Created by Ingo Böhme on 28.07.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import Foundation

struct VisitsSection {
    let sortKey: String
    let count: Int
}
extension RLMVisit {
    static var allSections: [VisitsSection] {
        let sections: [VisitsSection] =
            db.realm
            .objects(RLMVisit.self)
            .sorted(byKeyPath: "dateString", ascending: false)
            .distinct(by: ["dateString"])
            .map { VisitsSection(sortKey: $0.dateString, count: count($0.dateString))  }
        return sections
    }
    
    static func count(_ key: String) -> Int {
        db.realm
        .objects(RLMVisit.self)
        .filter("dateString = %@", key)
        .count

    }
    
    
}
