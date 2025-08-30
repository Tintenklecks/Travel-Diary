import SwiftUI

struct DiaryEntryCellViewCompact: View {
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
    
    var dayImage: some View {
        let prefix = diaryEntry.arrival.day(leadingZero: true)
        return Image(systemName: "\(prefix).square")
            .resizable()
            .frame(width: 32, height: 32)
            .foregroundColor(isFirstEntry ? .highlight : .clear)
    }
    
    var body: some View {
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
                            NSLocalizedString("Currently here", comment: "Currently here") : diaryEntry.departureTime
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
                    ),
                    onlyLocation: true,
                    toggle: self.$edit
                )
                .environmentObject(self.diaryEntry)
            }
        }
    }
}

struct DiaryEntryCellViewCompact_Previews: PreviewProvider {
    static var previews: some View {
        DiaryEntryCellViewCompact(diaryEntry: DiaryViewModel().sections.first!.entry(0))
    }
}
