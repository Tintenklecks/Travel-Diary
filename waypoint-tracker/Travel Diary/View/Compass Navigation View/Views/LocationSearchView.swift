import CoreLocation
import MapKit
import SwiftUI

struct LocationSearchView: View {
    @ObservedObject var viewModel = SearchTextViewModel()
    @ObservedObject var geoSearch = GeoSearch.shared
    @Binding var latitude: Double
    @Binding var longitude: Double
    
    @State private var scrollViewID = UUID()
    
    var displayBanner: Bool {
        #if canImport(GoogleMobileAds)
        if Int.random(in: 0..<8) == 0 {
            return true
        }
        #endif
        
        return false
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                IBTextField(
                    title: TXT.searchAdress,
                    text: $viewModel.searchText,
                    icon: Image(systemName: "magnifyingglass"),
                    showKeyboardButton: true,
                    showClearButton: true,
                    setFocus: false,
                    verticalPadding: 8) {
                    self.geoSearch.timedSearch(
                        searchText: self.viewModel.searchText, pois: self.viewModel.selectedPlacemarkId == "" ? [] : [MKPointOfInterestCategory(rawValue: self.viewModel.selectedPlacemarkId)]) { placemarks in
                        self.viewModel.placemarks = placemarks
                    }
                }
                .padding(EdgeInsets(top: 32, leading: 32, bottom: 8, trailing: 32))
                
                poiSelectionView()
                
                VStack {
                    if self.viewModel.placemarks.count == 0 {
                        Text(self.geoSearch.state.text)
                            .padding(32)
                        
                    } else {
                        ForEach(viewModel.placemarks) { placemark in
                            self.searchResultCell(placemark: placemark)
                        }
                    }
                    Spacer()
                }.padding(.horizontal, 32)
            }
            if self.geoSearch.state == .loading {
                ActivityIndicator(type: .spinningCircles)
                    .frame(width: 64, height: 64)
                    .padding(64)
                    .foregroundColor(.activityDark)
                    .offset(CGSize(width: 0, height: 40))
            }
        }
        .onAppear {
            self.viewModel.latitude = self.latitude
            self.viewModel.longitude = self.longitude
            
            self.geoSearch.center = CLLocation(latitude: self.viewModel.latitude, longitude: self.viewModel.longitude)
            self.geoSearch.timedSearch(searchText: "", pois: [], force: true) { placemarks in
                self.viewModel.placemarks = placemarks
            }
        }
    }
    
    func poiSelectionView() -> some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    Color.clear.frame(width: 16, height: 1)
                    ForEach(self.viewModel.pois, id: \.self) { poi in
                        
                        VStack(spacing: 0) {
                            Button(action: {
                                self.viewModel.searchText = ""
                                if self.viewModel.selectedPlacemarkId == poi.rawValue {
                                    self.viewModel.selectedPlacemarkId = ""
                                } else {
                                    self.viewModel.selectedPlacemarkId = poi.rawValue
                                }
                                self.geoSearch.timedSearch(searchText: "", pois: [poi], force: true) { placemarks in
                                    self.viewModel.placemarks = placemarks
                                }
                                
                                self.viewModel.pois.removeAll { $0 == poi }
                                self.viewModel.pois.insert(poi, at: 0)
                                MKPointOfInterestCategory.saveLocal(pois: self.viewModel.pois)
                                self.scrollViewID = UUID()
                                
                            }) {
                                Text(poi.localized)
                                    .font(.footnote)
                            }.buttonStyle(CapsuleStyleFilled(isSelected: self.viewModel.selectedPlacemarkId == poi.rawValue, depth: 1))
                        }
                    }
                }
                .padding(.bottom, 10)
            }
            .id(self.scrollViewID)
            .animation(.default)
            HStack {
                Spacer()
                LinearGradient(gradient: Gradient(
                    colors:
                    [Color.neoWhite.opacity(0),
                     Color.neoWhite.opacity(0.7),
                     Color.neoWhite]),
                               startPoint: .leading, endPoint: .trailing)
                    .frame(width: 50, height: 30)
            }
        }
    }
    
    @State var showCompass: Bool = false
    @State var destination = CompassViewModel()
    
    func searchResultCell(placemark: Placemark) -> some View {
        VStack(spacing: 0) {
            if self.displayBanner {
                Banner()
            }
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(placemark.name)
                        .font(.headline)
                        .foregroundColor(.highlight)
                    Text(placemark.localizedAddress(seperated: "\n"))
                        .layoutPriority(100)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    ActionButtonRound(image: Image(systemName: "safari")) {
                        DispatchQueue.main.async {
                            self.destination = CompassViewModel(
                                destinationName: placemark.name,
                                latitude: placemark.latitude,
                                longitude: placemark.longitude)
                            self.showCompass = true
                        }
                    }
                    .sheet(isPresented: self.$showCompass) {
                        CompassView(toggle: self.$showCompass, destination: self.destination)
                    }
                    ActionButtonRound(image: Image(systemName: "map")) {
                        placemark.location.openInMaps()
                    }
                    Spacer()
                }
            }
            HStack {
                Image(systemName: "arrow.left.and.right.square").resizable().scaledToFit().frame(height: 16)
                Text("\(placemark.distance.formattedDistanceWithUnit)")
                Text("\(placemark.latitude.latitudeString)")
                    .padding(.leading, 16)
                Text("\(placemark.latitude.latitudeString)")
                Spacer()
            }
            .font(.footnote)
            .foregroundColor(.secondary)
            .padding(.vertical, 4)
            
            Divider().padding(.vertical, 4)
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(latitude: .constant(47), longitude: .constant(8))
    }
}
