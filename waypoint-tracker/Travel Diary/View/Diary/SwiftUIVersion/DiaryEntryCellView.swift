import SwiftUI

struct DiaryEntryCellView: View {
    @ObservedObject var diaryEntry: DiaryEntryViewModel
    var isFirstEntry = false

    @EnvironmentObject var settings: UserSettings
    @Environment(\.colorScheme) var colorScheme
    
    @State private var details: Bool = false
    @State private var edit: Bool = false
    
    var stayDuration: String {
        if diaryEntry.secondsOfStay < 60 {
            return ""
        }
        return diaryEntry.secondsOfStay.timeString(withSeconds: false, condensed: true)
    }
    
    var body: some View {
        AnyView(Settings.cellStyle == .detailed ? cellView : cellView)
            .sheet(isPresented: .constant(self.details || self.edit), onDismiss: {
                self.edit = false
                self.details = false
            }) {
                if self.details {
                    DiaryEntryDetailView(diaryEntry: self.diaryEntry,
                                         toggle: self.$details)
                } else {
                    EntryEditView(
                        viewModel:
                        EntryEditViewModel(
                            id: self.diaryEntry.locationId,
                            name: self.diaryEntry.locationName
                        ), toggle: self.$edit
                    )
                    .environmentObject(self.diaryEntry)
                }
            }
    }
    
    var compactCellView: some View {
        VStack {
            if !isFirstEntry {
                Color.gray
                    .frame(height: 0.5)
                    .padding(.vertical, 8)
                    .opacity(0.5)
            }
            
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(diaryEntry.locationName)
                        
                        .font(.headline).lineLimit(1)
                        .foregroundColor(.action)
                        .onTapGesture {
                            self.edit.toggle()
                        }
                    
                    HStack {
                        Text(diaryEntry.arrivalTime)
                        Text("-")
                        Text(diaryEntry.isCurrent ?
                            "Currently here".localized : diaryEntry.departureTime
                        )
                        if !diaryEntry.isSameDay {
                            Text("*")
                        }
                        Text(diaryEntry.departureDate).foregroundColor(diaryEntry.isSameDay ? .clear : .primary)
                    }.font(.caption)
                }
                
                Spacer()
                
                ActionButtonRound(image: Image(systemName: "info")) {
                    self.details.toggle()
                }
                
                ActionButtonRound(image: Image(systemName: "map.fill")) {
                    self.diaryEntry.openInMaps()
                }
                
                ActionButtonRound(image: Image(systemName: self.diaryEntry.isFavorite ? "heart.fill" : "heart")) {
                    self.diaryEntry.toggleFavorite()
                }
            }
        }
        .padding(.horizontal, 12)

    }
    
    var cellView: some View {
        VStack(alignment: .leading) {
            ZStack {
                self.mapView
                    .onTapGesture {
                        self.details.toggle()
                    }
                    .padding(-10)
                
                self.mapOverlayGradientLeft
                    .padding(-10)
                //  self.mapOverlayGradientRight
                VStack {
                    self.headerView
                    self.arrivalDeparture
                    Spacer()
                    self.imageScroller
                    Spacer()
                    self.footerView
                }
            }
            // .border(Color.red)
        }
        .padding(12)
        .clipShape(RoundedRectangle(cornerRadius: 12))
//        .background(
//            Color.neoWhite
//                .clipShape(RoundedRectangle(cornerRadius: 12))
//                .shadow(color: .neoShadowTopLeft,
//                        radius: 10,
//                        x: -5, y: -5)
//                .shadow(color: .neoShadowBottomRight,
//                        radius: 10,
//                        x: 8, y: 8)
//        )
        .padding(.vertical, 12)
        .frame(width: UIScreen.main.bounds.size.width - 40, height: 240)
    }
    
    var headerView: some View {
        HStack {
            HStack {
                Text(diaryEntry.locationName)
                Image(systemName: "square.and.pencil")
            }
            .font(.headline).lineLimit(1)
            .foregroundColor(.action)
            .padding([.leading, .trailing], 8)
            .padding([.top, .bottom], 4)
            .onTapGesture {
                self.edit.toggle()
            }
            Spacer()
            Image(systemName: self.diaryEntry.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(.action)
                .onTapGesture {
                    self.diaryEntry.toggleFavorite()
                }
        }
    }
    
    var footerView: some View {
        HStack {
            if self.diaryEntry.secondsOfStay > 60 {
                Image(systemName: "timer")
                Text(self.diaryEntry.secondsOfStay.timeString())
            } else {
                Text("Currently here".localized)
            }
            Spacer()
            Text(self.diaryEntry.latitude.latitudeString)
            Text(self.diaryEntry.longitude.longitudeString)
        }
        .padding([.leading, .trailing], 8)
        .padding([.top, .bottom], 4)
        .offset(y: 10)
        .foregroundColor(.info)
        .font(.caption)
    }
    
    var arrivalDeparture: some View {
        VStack {
            HStack {
                Image.departure
                Text(self.diaryEntry.departure.shortTime).foregroundColor(self.diaryEntry.isCurrent ? .clear : .departure)
                Spacer()
            }
            
            HStack {
                Image.arrival
                Text(self.diaryEntry.arrivalTime).foregroundColor(.arrival)
                Spacer()
            }
        }
    }
    
    @State var selectedImageId: String = ""
    var imageScroller: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 16) {
                ForEach(self.diaryEntry.photos.photos) { image in
                    image.image
                        .resizable().scaledToFit()
                        .border(Color.white, width: 2)
                        // .frame(height: 64)
                        .padding(4)
                        .shadow(color: .headerShadow, radius: 1, x: 0.8, y: 0.8)
                        
                        .onTapGesture {
                            self.selectedImageId = image.id
                        }
                        .sheet(isPresented: .constant(self.selectedImageId != ""), onDismiss: {
                            self.selectedImageId = ""
                        }) {
                            PhotoDetailView(imageId: self.$selectedImageId)
                        }
                }
                Text("")
            }
        }
        .frame(height: 48)
    }
    
    var mapView: some View {
        GeometryReader { proxy in
            
            MapView(diaryEntry: self.diaryEntry, radius: 250,
                    width: Double(proxy.size.width), height: 140, darkMode: self.colorScheme == .dark)
                .scaledToFill()
        }
    }
    
    var mapOverlayGradientLeft: some View {
        HStack {
            LinearGradient(gradient: Gradient(colors: [.neoWhite, .neoWhite, Color.neoWhite.opacity(0)]), startPoint: .leading, endPoint: .trailing)
                .frame(width: 200) // , height: 140)
            Spacer()
        }
        .offset(x: -10, y: 0)
    }
    
    var mapOverlayGradientRight: some View {
        HStack {
            Spacer()
            LinearGradient(gradient: Gradient(colors: [Color.neoWhite.opacity(0), .neoWhite]), startPoint: .leading, endPoint: .trailing)
                .frame(width: 20) // , height: 140)
        }
        .offset(x: 10, y: 0)
    }
}
