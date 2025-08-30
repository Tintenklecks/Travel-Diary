import SwiftUI

struct TravelTimeCell: View {
    @ObservedObject var diaryEntry: DiaryEntryViewModel

    var body: some View {
        HStack {
            VStack {
                Divider()
            }
            Image(systemName: "timer")
            Text(diaryEntry.secondsOnTheRoad.timeString(withSeconds: false))
            VStack {
                Divider()
            }
        }
        .font(.caption)
        .foregroundColor(.info)
    }
}
