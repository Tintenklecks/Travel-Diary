import CoreLocation
import SwiftUI

struct WikiEntryView: View {
    @Environment(\.imageCache) var cache: ImageCache

    let page: WikipediaRecord
    @State private var showCompass: Bool = false
    @State private var destination = CompassViewModel()
    var displayBanner: Bool {
        if Int.random(in: 0..<8) == 0 {
            return true
        }
        return false
    }
    var url: URL? {
        if let thumbURL = URL(string: page.thumbnail) {
            return thumbURL
        }
        return nil
//        return Bundle.main.url(forResource: "nopic", withExtension: "png")!
    }

    var body: some View {
        VStack(spacing: 0) {
            if displayBanner {
                Banner()
            }
            HStack {
                if url == nil {
                    Image("nopic")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                } else {
                    AsyncImage(
                        url: url!,
                        cache: self.cache,
                        placeholder:
                        ActivityIndicator(type: .rotatingFan)
                            .foregroundColor(.activityDark)
                            .frame(width: 60, height: 60),
                        configuration: { $0.resizable() }
                    )
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                }
                Text(page.title)
                    .font(.body)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)
                Image(systemName: "light.min")

                Text(page.distance.formattedDistanceWithUnit)
                    .font(.caption).foregroundColor(.secondaryText)
                ActionButtonRound(
                    image:
                    Image(systemName: "safari")
                ) {
                    self.destination = CompassViewModel(
                        destinationName: self.page.title,
                        latitude: self.page.latitude, longitude: self.page.longitude
                    )
                    self.showCompass = true
                }
                ActionButtonRound(
                    image:
                    Image(systemName: "map")
                ) {
                    let location = CLLocation(latitude: self.page.latitude, longitude: self.page.longitude)
                    location.openInMaps()
                }
            }
            .padding(.vertical, 4)
            .sheet(isPresented: self.$showCompass) {
                CompassView(toggle: self.$showCompass, destination: self.destination)
            }
        }
    }
}
