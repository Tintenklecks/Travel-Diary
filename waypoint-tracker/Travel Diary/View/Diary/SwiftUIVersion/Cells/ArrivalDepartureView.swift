import SwiftUI

struct ArrivalDepartureView: View {
    let diaryEntry: DiaryEntryViewModel

    var stayDuration: String {
        if diaryEntry.secondsOfStay < 60 {
            return ""
        }
        return diaryEntry.secondsOfStay.timeString(withSeconds: false, condensed: true)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image.coloredImage("departure", in: .departure)
                    Text("\(self.diaryEntry.departureTime) ")
                        .foregroundColor(.departure)
                }
                Spacer()
                HStack {
                    Image.coloredImage("arrival", in: .arrival)
                    Text("\(self.diaryEntry.arrivalTime) ")
                        .foregroundColor(.arrival)
                }
            }
          //  .frame(width: 200, height: 80)
            .font(.body)
            .padding([.top, .bottom], 16)

            Text(stayDuration)
                .rotationEffect(Angle(degrees: -90))
                .foregroundColor(.info)
                .font(.caption)

            //   .offset(x: -8, y: 0)
        }
    }
}
