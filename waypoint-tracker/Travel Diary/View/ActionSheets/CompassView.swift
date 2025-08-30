//
import Combine
import SwiftUI

struct CompassView: View {
    @Binding var toggle: Bool
    var destination: CompassDataProtocoll

    @State private var headingPublisher: AnyCancellable?
    @State private var heading: Double = 0
    @State private var accuracy: Double = 360

    var color: UIColor {
        let headingData = HeadingData(heading: heading, accuracy: accuracy)
        return headingData.uiColor
    }

    @State private var bearing: Double = 0

    var arrowImage: Image {
        Image.coloredImage("compassRoseArrow", in: color)
    }


    #if os(iOS)
    let padding = CGFloat(32)
    let rosePadding = EdgeInsets(top: 42, leading: 42, bottom: 42, trailing: 42)
    let compassPadding = EdgeInsets(top: 32, leading: 32, bottom: 32, trailing: 32)
    #elseif os(watchOS)
    let padding = CGFloat(4)
    let rosePadding = EdgeInsets(top: 0, leading: -10, bottom: -20, trailing: -10)
    let compassPadding = EdgeInsets(top: 0, leading: -16, bottom: -32, trailing: -16)
    #endif

    var body: some View {
        VStack(spacing: 0) {
            #if os(iOS)
            ActionSheetHeader(
                title: TXT.towards +
                " \(self.destination.destinationName)",
                leftButtonSystemImage: "xmark"
            ) { _ in
                self.toggle.toggle()
            }
            #endif
            ZStack {
                VStack {
                    #if os(iOS)

                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 0) {
                            Text(destination.distanceFromLocation.formattedDistanceWithUnit).font(.largeTitle).foregroundColor(.info)
                            HStack {
                                Text(TXT.distanceTo)
                                Text(self.destination.destinationName).bold().foregroundColor(.red)
                            }.font(.caption).foregroundColor(.info)
                        }
                    }
                    .padding(padding)

                    Spacer()
                    HStack {
                        Spacer()
                        Text(TXT.redArrowPointsTowards)
                        Text(self.destination.destinationName).foregroundColor(.red).bold()
                        Spacer()
                    }
                    .font(.caption).padding(self.padding)
                    #elseif os(watchOS)
                    HStack {
                        Spacer()
                        Text(self.destination.distanceFromLocation.formattedDistanceWithUnit).font(.caption).foregroundColor(.info)
                            .padding(.trailing, 8)
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Text(self.destination.destinationName).font(.caption).foregroundColor(.red).lineLimit(1)
                    }.padding(.trailing, 8)
                    #endif
                }

                Image.compassRose
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(Angle(degrees: self.heading))
                    .padding(self.compassPadding)
                    .opacity(0.5)
                self.arrowImage
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(Angle(degrees: self.bearing))
                    .shadow(radius: 5)
                    .padding(self.rosePadding)
            }
        }
        .background(Color.neoWhite.edgesIgnoringSafeArea(.all))
        .onAppear {
            LocationPublisher.shared.execute { _ in
//                self.exactLocation = true
            }

            self.headingPublisher =
                LocationPublisher.shared.headingPublisher.sink { headingData in
                    self.heading = 360 - headingData.heading
                    self.accuracy = headingData.accuracy
                    self.bearing = self.destination.bearing + self.heading
                }
        }
    }
}

struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CompassView(toggle: .constant(true), destination: CompassViewModel(destinationName: "Sonstwohin", latitude: 47.2, longitude: 17.5))
            CompassView(toggle: .constant(true), destination: CompassViewModel(destinationName: "Sonstwohin", latitude: 10, longitude: 17.5))
        }
    }
}
