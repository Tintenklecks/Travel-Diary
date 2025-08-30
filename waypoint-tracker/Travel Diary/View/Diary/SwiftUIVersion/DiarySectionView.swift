import SwiftUI

struct DiarySectionView: View {
    @ObservedObject var section: DiarySectionViewModel
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        Section(header: SectionHeaderView(section: section)) {
            VStack {
//                Text("\(Date().description)  ***\(section.sortableDateString)")
                ForEach(0..<self.section.count, id: \.self) { index in
                    
                    DiaryEntryCellView(diaryEntry: self.section.entry(index), isFirstEntry: index == 0)
                        .environmentObject(self.settings)


                }
                .onDelete { self.delete(at: $0) }
            }

        }

    }

    func delete(at offsets: IndexSet) {
        section.delete(offsets: offsets)
    }
}
