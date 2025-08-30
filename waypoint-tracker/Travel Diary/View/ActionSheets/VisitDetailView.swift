import CoreLocation
import SwiftUI

struct DiaryEntryDetailView: View {
    @State var diaryEntry: DiaryEntryViewModel
    @ObservedObject var wikiViewModel = WikipediaViewModel()

    @Binding var toggle: Bool

    @State private var mapStyle: Int = Settings.mapStyle.rawValue

    var title: String {
        return diaryEntry.headline
    }

    var subTitle: String {
        var result = "\(diaryEntry.arrival.shortDate) \(diaryEntry.arrival.shortTime) - "

        if diaryEntry.departure.shortDate != diaryEntry.arrival.shortDate {
            if diaryEntry.departure == Date.distantFuture {
                result += "currently here"
                return result
            } else {
                result += "\(diaryEntry.departure.shortDate) "
            }
        }

        result += diaryEntry.arrival.shortTime
        return result
    }

    @State private var fullScreenMap = false
    @State private var edit = false

    var body: some View {
        VStack(spacing: 0) {
            ActionSheetHeader(
                title: diaryEntry.locationName,
                subTitle: self.subTitle,
                leftButtonSystemImage: "xmark",
                leftAccessability: .closeDialogButton,
                rightButtonSystemImage: "square.and.pencil",
                rightAccessability: Accessability.editEntryButton
            ) { button in
                if button == ActionSheetHeader.Buttons.right {
                    self.edit = true
                } else {
                    self.toggle.toggle()
                }
            }

            GeometryReader { geoProxy in
                ScrollView {
                    self.map(small: geoProxy.size.height / 3, large: geoProxy.size.height)

                    self.diaryText

                    self.wikipediaList

                    Spacer()
                }
            }
        }
        .onAppear {
            self.wikiViewModel.latitude = self.diaryEntry.latitude
            self.wikiViewModel.longitude = self.diaryEntry.longitude

            self.wikiViewModel.fetchData()
        }
        .sheet(isPresented: $edit) {
            EntryEditView(
                viewModel:
                EntryEditViewModel(
                    id: self.diaryEntry.locationId,
                    name: self.diaryEntry.locationName,
                    headline: self.diaryEntry.headline,
                    text: self.diaryEntry.text

                ), onlyLocation: false, toggle: self.$edit
            )
            .environmentObject(self.diaryEntry)
        }

        .navigationBarTitle(Text(self.title), displayMode: .inline)
    }

    func map(small: CGFloat, large: CGFloat) -> some View {
        ZStack(alignment: .topTrailing) {
            MapKitView(location: CLLocationCoordinate2D(latitude: self.diaryEntry.latitude, longitude: self.diaryEntry.longitude), radius: 500.0, style: $mapStyle)
            
            VStack(alignment: .trailing, spacing: 8) {
                ActionButtonRound(
                    image:
                    Image(systemName: self.fullScreenMap ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                ) {
                    withAnimation {
                        self.fullScreenMap.toggle()
                    }

                }
                SegmentedButton(id: 0, selectedId: self.$mapStyle, title: TXT.map)
                SegmentedButton(id: 1, selectedId: self.$mapStyle, title: TXT.satellite)
                SegmentedButton(id: 2, selectedId: self.$mapStyle, title: TXT.hybrid)
            }.padding(8)

        }.frame(height: fullScreenMap ? large : small)
    }

//    var mapInfo: some View {
//        HStack(alignment: .top) {
//            VStack(alignment: .leading) {
//                Text("")
//            }
//            .font(.caption)
//            .background(Color.neoWhite)
//            Spacer()
//            ActionButton(
//                image: Image(systemName: "map"),
//                caption: "Route"
//            ) {
//                self.diaryEntry.openInMaps()
//            }
//        }.padding()
//    }

    var diaryText: some View {
        VStack(alignment: .leading, spacing: 8) {
            Color.clear.frame(height: 1)
            Text(self.diaryEntry.headline).font(.headline)
            Text(self.diaryEntry.text)
                .font(.body)
                .italic()
                .fontWeight(.light)
                .foregroundColor(.info)
        }.padding([.horizontal, .bottom])
    }

    var wikipediaList: some View {
        if wikiViewModel.state == .loaded {
            return
                ScrollView {
                    Divider()
                    WikipediaListView(wiki: self.wikiViewModel)
                }.asAnyView()
        } else if wikiViewModel.state == .loading {
            return
                ActivityIndicator(type: .rotatingFan)
                .foregroundColor(.activityDark)
                .frame(width: 64, height: 64)
                .asAnyView()
        } else {
            return Text("").asAnyView()
        }
    }
}

struct SegmentedButton: View {
    let id: Int
    @Binding var selectedId: Int
    let title: String

    var body: some View {
        Button(title) {
            self.selectedId = self.id
        }
        .font(.footnote)
        .buttonStyle(CapsuleStyleFilled(isSelected: id == selectedId, depth: 0))
    }
}
