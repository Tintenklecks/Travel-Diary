import SwiftUI

struct DiarySectionViewCompact: View {
    @ObservedObject var section: DiarySectionViewModel
    @EnvironmentObject var settings: UserSettings

    var body: some View {
            Section(
                header:
                HStack {
                    Color.highlight.frame(height: 0.5)
                    Text(section.sortableDateString.dateFromSortedDateFormat.longDate).layoutPriority(100)
                        .foregroundColor(.primary)
                    Color.highlight.frame(height: 0.5)
                }
                .foregroundColor(.highlight)) {
                ForEach(0..<self.section.count, id: \.self) { index in
                    DiaryEntryCellViewCompact(
                        diaryEntry: self.section.entry(index),
                        isFirstEntry: index == 0)
                        .environmentObject(self.settings)
                }
            }
        .padding(.top, 16)
    }

//    func delete(at offsets: IndexSet) {
//        section.delete(offsets: offsets)
//    }
}
