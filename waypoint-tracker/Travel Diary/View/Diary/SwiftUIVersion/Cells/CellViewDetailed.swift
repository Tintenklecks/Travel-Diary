import SwiftUI


struct DetailedCellView: View {
    

    let diaryEntry: DiaryEntryViewModel
    var body: some View {
        NeomorphicRectangle {
            GeometryReader { proxy in
                VStack {
                    ZStack(alignment: .bottomLeading) {
                        VStack {
                            MapView(diaryEntry: self.diaryEntry, radius: 5000)
                                .scaledToFit()
                                .frame(width: proxy.size.width, height: 240)
                                .clipped()
                                .shadow(radius: 4)
                            Spacer()
                        }
                        if self.diaryEntry.headline != "" {
                            Text(self.diaryEntry.headline)
                                .padding([.top, .bottom], 4)
                                .padding([.leading, .trailing], 8)
//                            .background(Blur())
                                .padding([.leading, .bottom], 12)
                        }
                        VStack {
                            HStack {
                                Spacer()
                                HStack {
                                    Image("arrival")
                                    Text(self.diaryEntry.arrivalTime)

                                    Image("departure")
                                    Text(self.diaryEntry.departureTime)
                                }
                                .padding([.top, .bottom], 4)
                                .padding([.leading, .trailing], 8)
                                .background(Blur())
                                .padding([.trailing, .top], 12)
                            }
                            Spacer()
                        }
                        HStack {
                            Spacer()

                            HStack { Text(self.diaryEntry.latitude.latitudeString)
                                Text(self.diaryEntry.longitude.longitudeString)
                            }
                            .padding([.top, .bottom], 4)
                            .padding([.leading, .trailing], 8)
                            .background(Blur())
                            .padding([.trailing, .bottom], 8)
                        }
                        .font(.caption)
                        .padding([.trailing, .bottom], 4)
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height / 2)

                    if self.diaryEntry.imageCount > 0 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .center, spacing: 16) {
                                ForEach(self.diaryEntry.photos.photos) { image in

                                    image.image
                                        .resizable().scaledToFit().frame(height: 64)
                                        .onTapGesture {}
                                }
                            }
                        }
                    }

                    if self.diaryEntry.text != "" {
                        Text(self.diaryEntry.text)
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                            .lineLimit(2)
                    }

                    Spacer()
                } // .border(Color.red, width: 5)
            }
        }
    }
}


struct WaypointCellWithImages_Previews: PreviewProvider {
    let diaryEntry: DiaryEntryViewModel = DiaryViewModel().waypoints[0]

    static var previews: some View {
        DetailedCellView(diaryEntry: DiaryEntryViewModel(
            arrival: Date(timeIntervalSinceNow: -60),
            departure: Date(timeIntervalSinceNow: 60),
            longitude: 99.1,
            latitude: 7.85))
            .frame(height: 240)
    }
}
