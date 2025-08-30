//

import SwiftUI

enum WeekDay: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    var color: Color {
        switch self {
        case .monday:
            return Color(hex: "778C7D")
        case .tuesday:
            return Color(hex: "778C7D")
        case .wednesday:
            return Color(hex: "BCB0B8")
        case .thursday:
            return Color(hex: "0x7E6776")
        case .friday:
            return Color(hex: "CEA0A5")
        case .saturday:
            return Color(hex: "9E4B54")
        case .sunday:
            return Color(hex: "800000")
        }
    }
}

struct CellView: View {
    @ObservedObject var entry: WKDiaryEntryViewModel
    @State private var isFavorite = false {
        didSet {
            entry.isFavorite = isFavorite
        }
    }

    var color: Color {
        return WeekDay(rawValue: entry.arrival.weekday)?.color ?? Color.clear
    }

    var gradient: LinearGradient {
        let color = self.color
        let colorArray = [
            color.opacity(0),
            color.opacity(0.5),
            color.opacity(0.5),
            color.opacity(0.5),
            color.opacity(0.3),
            color.opacity(0)
        ]
        return LinearGradient(gradient: Gradient(colors: colorArray), startPoint: .leading, endPoint: .trailing)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            self.gradient
            Text("\(entry.arrival.weekdayAbbrevationShort) \(entry.arrival.monthAndDayNumeric)")
                .offset(x: 0, y: 3)
                .font(.footnote)
                .frame(width: 90, height: 24)
                .background(self.color)
                .offset(CGSize(width: 0, height: -40))
                .lineLimit(1)
                .rotationEffect(Angle(degrees: 270))
            VStack(alignment: .leading, spacing: 0) {
                Text("\(entry.locationName)").fontWeight(.medium)
                    .lineLimit(2).font(.body)
                    .padding(.bottom, 4)

                HStack {
                    Text("\(entry.timeSpan)")
                    Spacer()

//                    Image(systemName: self.isFavorite ? "heart.fill" : "heart")
//                        .onTapGesture {
//                            self.isFavorite.toggle()
//                        }
                }
                .font(.footnote)
            }
            .frame(height: 80)
            .padding(.leading, 24)
        }
        .clipped()

        .onAppear {
            self.isFavorite = self.entry.isFavorite
            Settings.lastDestination = (self.entry.locationName, CLLocation(latitude: self.entry.latitude, longitude: self.entry.longitude))
        }
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CellView(entry: WKDiaryEntryViewModel(
                arrival: Date(timeIntervalSinceNow: -150),
                departure: Date(timeIntervalSinceNow: +150),
                latitude: 47.5, longitude: 7, locationName: "Zofingen, Aargau", favorite: true))
            CellView(entry: WKDiaryEntryViewModel(
                arrival: Date(timeIntervalSinceNow: 95000),
                departure: Date(timeIntervalSinceNow: 100000),
                latitude: 47.1, longitude: 7.4, locationName: "Sowas", favorite: false))
        }
    }
}
