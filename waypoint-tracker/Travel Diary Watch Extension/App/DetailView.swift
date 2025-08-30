//

import SwiftUI

struct DetailView: View {
    let entry: WKDiaryEntryViewModel
    @State private var showCompass: Bool = false
    var color: Color {
        WeekDay(rawValue: entry.arrival.weekday)?.color ?? Color.clear
    }

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(entry.locationName)").font(.headline)
                    Text("\(entry.dateSpan)")
                    Text("\(entry.timeSpan)")

                    HStack {
                        if self.entry.secondsOfStay > 60 {
                            Image(systemName: "timer")
                            Text(self.entry.secondsOfStay.timeString())
                        } else {
                            Text(TXT.currentlyHere)
                        }
                        Image(systemName: "arrow.left.and.right.square").padding(.leading, 8)
                        Text(self.entry.distanceFromLocation.formattedDistanceWithUnit)
                    }
                    HStack {
                        Text(self.entry.latitude.latitudeString)
                        Text(self.entry.longitude.longitudeString)
                    }
                    Color.clear.frame(height: 1)
                }.padding(8)
            }
            .font(.caption)
            .background(
                LinearGradient(gradient:
                    Gradient(colors: [self.color, self.color, self.color.opacity(0)]),
                               startPoint: .top, endPoint: .bottom))

            #if !targetEnvironment(simulator)
                WatchMapView(entry: self.entry)
                    .frame(height: 160)
            #endif
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 64)
                .foregroundColor(Color.action)
                .overlay(
                    HStack {
                        Image("compassIcon").resizable().scaledToFit().frame(width: 24, height: 24)
                        Text(TXT.compass)
                    }
                )

                .onTapGesture {
                    self.showCompass.toggle()
                }

            Text(Settings.version).font(.footnote).foregroundColor(.red)
        }
        .padding()
        .sheet(isPresented: $showCompass) {
            CompassView(toggle: self.$showCompass, destination: self.entry)
        }
        .navigationBarTitle(TXT.details)
    }
}

struct WatchMapView: WKInterfaceObjectRepresentable {
    var entry: WKDiaryEntryViewModel

    func makeWKInterfaceObject(context: WKInterfaceObjectRepresentableContext<WatchMapView>) -> WKInterfaceMap {
        // Return the interface object that the view displays.
        let map = WKInterfaceMap()
        return map
    }

    func updateWKInterfaceObject(_ map: WKInterfaceMap, context: WKInterfaceObjectRepresentableContext<WatchMapView>) {
        // Update the interface object.
        let span = MKCoordinateSpan(latitudeDelta: 0.02,
                                    longitudeDelta: 0.02)

        let region = MKCoordinateRegion(
            center: entry.location.coordinate,
            span: span)

        map.addAnnotation(entry.location.coordinate,
                          with: .green)
        map.setRegion(region)
    }
}

struct DetailView_Previews: PreviewProvider {
    static let entry = WKDiaryEntryViewModel(
        arrival: Date(), departure: Date(timeIntervalSinceNow: 150), latitude: 47, longitude: 7, locationName: "Somewhere", favorite: true)

    static var previews: some View {
        DetailView(entry: DetailView_Previews.entry)
    }
}
