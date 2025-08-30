import SwiftUI

struct GeoPositionView: View {
    let diaryEntry: DiaryEntryViewModel
    var body: some View {
        VStack(alignment: .trailing) {
            Text("\(self.diaryEntry.latitude.latitudeString)")
            Text("\(self.diaryEntry.longitude.longitudeString)")
        }.font(.caption)
    }
}
