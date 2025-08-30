import CoreLocation
import IBExtensions
// import IBGeoSelection
import SwiftUI

struct DestinationSelectionView: View {
    @ObservedObject var viewModel = CompassViewModel()
    @State private var selection = DestinationEditSelection.none
    @State private var showCompass = false

    let numberFormatter = NumberFormatter()
    var body: some View {
        IBNavigationView(title: TXT.navigation, actionView: Text("")) {
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    GeoSelectionView(selected: self.$selection, type: .latitude, value: self.$viewModel.latitude)
                        .padding(.leading, 16)
                    GeoSelectionView(selected: self.$selection, type: .longitude, value: self.$viewModel.longitude)
                        .offset(x: 0, y: -16)
                        .padding(.leading, 16)
                        .padding(.bottom, -16)

                    HStack {
                        Spacer()
                        ActionButton(image: Image(systemName: "safari"), caption: TXT.compass) {
                            self.selection = .none
                            self.showCompass = true
                            self.viewModel.destinationName = "\(self.viewModel.latitude.latitudeString)  \(self.viewModel.longitude.longitudeString)"
                        }
                        .sheet(isPresented: self.$showCompass) {
                            CompassView(toggle: self.$showCompass, destination: self.viewModel)
                        }
                        Spacer()
                        ActionButton(image: Image(systemName: "map"), caption: TXT.navigationMaps) {
                            self.selection = .none
                            self.viewModel.location.openInMaps()
                        }
                        Spacer()
                    }
                    .padding(.bottom, 8)
                }
                .padding(8)
                .modifier(NeoStyleModifier(size: 8))
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                .padding(.top, 16)

                LocationSearchView(latitude: self.$viewModel.latitude, longitude: self.$viewModel.longitude)
            }
        }
    }
}

struct DestinationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationSelectionView()
    }
}

enum DestinationEditSelection {
    case none
    case latitude
    case longitude
    case search

    var text: String {
        switch self {
        case .latitude:
            return TXT.geoLatitude
        case .longitude:
            return TXT.geoLongitude
        case .search:
            return TXT.search
        default: return ""
        }
    }
}
