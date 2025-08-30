import Combine
import CoreLocation
import Foundation
import SwiftUI

import RealmSwift

class DiarySectionViewModel: ObservableObject, Identifiable {
    var sortableDateString: String
    let id = UUID()
    private var dbSection: RLMSection?

    var count: Int = 0

    private func getDBData() -> RLMSection? {
        if dbSection == nil {
            dbSection = RLMSection.getSection(for: sortableDateString)
        }
        return dbSection
    }

    func entry(_ index: Int) -> DiaryEntryViewModel {
        if let dbSection = getDBData() {
            return DiaryEntryViewModel.from(model: dbSection.visits[index])
        } else {
            return DiaryEntryViewModel()
        }
    }

    func entries() -> [DiaryEntryViewModel] {
        if let dbSection = getDBData() {
            print("ACCESS ENTRIES IN SECTION \(sortableDateString)")
            return dbSection.visits.sorted(byKeyPath: "arrival", ascending: false).map { DiaryEntryViewModel.from(model: $0) }
        } else {
            return []
        }
    }

    init(sortableDateString: String) {
        self.sortableDateString = sortableDateString
    }

    func delete(offsets: IndexSet) {
        guard let dbSections = dbSection else {
            return
        }

        let sortedIndices = offsets.sorted(by: { $0 > $1 })
        var count = 0

        for offset in sortedIndices {
            if offset < self.count {
                dbSections.visits[offset].delete()
                count += 1
            }
        }
        if count > 1 {
            objectWillChange.send()
        }
    }
    
    static var all: [String] {
        RLMVisit.allSections
    }
}
