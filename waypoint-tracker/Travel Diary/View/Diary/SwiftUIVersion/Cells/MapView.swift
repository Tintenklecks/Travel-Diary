import CoreLocation
import SwiftUI

struct MapView: View {
    let diaryEntry: DiaryEntryViewModel
    var radius: Double = 2000
    var width: Double = 600
    var height: Double = 100
    var size: CGSize {
        return CGSize(width: self.width, height: self.height)
    }
    var darkMode: Bool = false

    @State private var image = UIImage()

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .clipped()
            .onAppear {
                CLLocationCoordinate2D(
                    latitude: self.diaryEntry.latitude,
                    longitude: self.diaryEntry.longitude)
                    .mkMapImage(
                        radius: self.radius,
                        size: self.size) { image in
                        self.image = image
                    }
            }
    }
}
