//
//  DiarySectionsViewModel.swift
//  Travel Diary
//
//  Created by Ingo Böhme on 28.07.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import Foundation
import CoreLocation

enum DiaryGroupTyp {
    case day
    case area
    
}

class DiarySectionsViewModel: ObservableObject, Identifiable {
    var sections: [VisitsSection] = []
    var count: Int { sections.count }
    var groupType: DiaryGroupTyp = .day
    var selectedKey: String = ""
    var selectedEntries: [DiaryEntryViewModel] = []
    
    init() {
        reload()
    }
    
    func reload() {
        sections = DiaryEntryViewModel.allSections
        if groupType == .day {
            setKey(sortableDate: selectedKey)
        } // TODO: Other variants of sectioning
    }
    
    var counter = 0
    func setKey(sortableDate string: String) {
        
        if selectedKey != string {
            counter += 1
            selectedKey = string
            self.selectedEntries = DiaryEntryViewModel.entries(for: selectedKey)
        }
    }
    
    
    func getEntry(index: IndexPath) -> DiaryEntryViewModel? {
        if index.section < sections.count {
            setKey(sortableDate: sections[index.section].sortKey)
            if index.row < selectedEntries.count {
                return selectedEntries[index.row]
            }
        }
        return nil
    }
}
