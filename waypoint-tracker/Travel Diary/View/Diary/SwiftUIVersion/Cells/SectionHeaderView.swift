import SwiftUI

struct SectionHeaderView: View {
    @ObservedObject var section: DiarySectionViewModel
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        if Settings.cellStyle == .detailed {
            return bigHeader.asAnyView()
        } else {
            return compactHeader.asAnyView()
        }
    }

    var compactHeader: some View {
        HStack {
            Color.highlight.frame(height: 0.5)
            Text(self.section.sortableDateString.dateFromSortedDateFormat.longDate).layoutPriority(100)
                .foregroundColor(.primary)
            Color.highlight.frame(height: 0.5)
        }
        .foregroundColor(.highlight)
    }

    var bigHeader: some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom) {
                Text("  \(self.section.sortableDateString.dateFromSortedDateFormat.weekdayText.uppercased())")
            Spacer()
                Text("\(self.section.sortableDateString.dateFromSortedDateFormat.monthAndDay)  ")
            }
            .font(Font.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(.highlight)
            .padding(.bottom, 8)
            .padding([.leading, .trailing], 8)
        }

        // .foregroundColor(.imageTag)
        .frame(height: 80)
        .listRowInsets(EdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        ))
        .background(
            LinearGradient(gradient: Gradient(colors: Color.headerGradients), startPoint: .top, endPoint: .bottom)
                .shadow(color: .headerShadow, radius: 2, x: 0, y: 3)
        )
    }
}
