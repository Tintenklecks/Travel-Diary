import Combine
import StoreKit
import SwiftUI

struct DiaryView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var diary: DiaryViewModel

    @State var diaryEntry = DiaryEntryViewModel()
    @State var action: ActionType = .idle {
        didSet {
            if self.action == .idle {
                self.toggle = false
            } else {
                self.toggle = true
            }
        }
    }

    @State var editLocationListener: AnyCancellable?
    @State var showDetailsListener: AnyCancellable?
    @State var compassListener: AnyCancellable?
    @State private var reloadDataListener: AnyCancellable?

    @State var toggle: Bool = false

    @State private var cellStyleCompact = Settings.cellStyle == .compact

    var body: some View {
        return ZStack {
            if diary.sections.count == 0 {
                NoEntriesView().environmentObject(diary)

            } else {
                IBNavigationView(title: "CFBundleDisplayName".localized,
                                 actionView:
                                 HStack {
                                     showPictureButton.padding(.trailing, 16)
                                         .opacity(self.cellStyleCompact ? 0 : 1)
                                     cellStyleButton.padding(.trailing, 8)
                }) {
                    VStack(spacing: 0) {
                        #if canImport(GoogleMobileAds)
                        Banner()
                        #endif
                        DiaryTableViewWrapper()
                            .environmentObject(self.diary)
                            .sheet(isPresented: self.$toggle, onDismiss: { self.action = .idle }) {
                                if self.action == ActionType.detail {
                                    DiaryEntryDetailView(diaryEntry: self.diaryEntry, toggle: self.$toggle)
                                        .environmentObject(self.diaryEntry)
                                } else if self.action == ActionType.editLocation {
                                    EntryEditView(
                                        viewModel:
                                        EntryEditViewModel(
                                            id: self.diaryEntry.locationId,
                                            name: self.diaryEntry.locationName
                                        ),
                                        onlyLocation: true, toggle: self.$toggle
                                    )
                                    .environmentObject(self.diaryEntry)
                                } else if self.action == ActionType.compass {
                                    CompassView(toggle: self.$toggle, destination: self.diaryEntry)
                                }
                            }
                            .onAppear {
                                if Settings.showReview { SKStoreReviewController.requestReview()
                                }
                            }
                    }
                }
            }
        }
        .onAppear {
            self.instanciateListeners()
        }
    }

    var cellStyleButton: some View {
        Button(action: {
            withAnimation {
                if Settings.cellStyle == CellStyle.compact {
                    Settings.cellStyle = .detailed
                } else {
                    Settings.cellStyle = .compact
                }
                self.cellStyleCompact = Settings.cellStyle == .compact
                AppNotification.sendReloadData()
            }
        }) {
            Image(systemName: self.cellStyleCompact ? "doc.text.magnifyingglass" : "list.dash")
                .setAccessability(.toggleLayout)
        }
    }

    var showPictureButton: some View {
        Button(action: {
            withAnimation {
                self.settings.showPictures.toggle()
//                Settings.showPictures.toggle()
                AppNotification.sendReloadData()
            }
        }) {
            Image(systemName: "photo.on.rectangle")
                .foregroundColor(self.settings.showPictures ? .info : .action)
                .setAccessability(.togglePictures)
        }
    }

    func instanciateListeners() {
        self.reloadDataListener = NotificationCenter.default.publisher(for: AppNotification.reloadData)
            .sink { _ in
                // ***###
            }

        self.editLocationListener = NotificationCenter.default.publisher(for: AppNotification.editLocation)
            .sink { receivedNotification in
                if let entry = receivedNotification.object as? DiaryEntryViewModel {
                    self.diaryEntry = entry
                    self.action = ActionType.editLocation
                    self.toggle = true
                }
            }

        self.showDetailsListener = NotificationCenter.default.publisher(for: AppNotification.showDetail)
            .sink { receivedNotification in
                if let entry = receivedNotification.object as? DiaryEntryViewModel {
                    self.diaryEntry = entry
                    self.action = ActionType.detail
                    self.toggle = true
                }
            }

        self.compassListener = NotificationCenter.default.publisher(for: AppNotification.showCompass)
            .sink { receivedNotification in
                if let entry = receivedNotification.object as? DiaryEntryViewModel {
                    self.diaryEntry = entry
                    self.action = ActionType.compass
                    self.toggle = true
                }
            }
    }
}

struct NoEntriesView: View {
    @EnvironmentObject var diary: DiaryViewModel
    @State private var waiting = false
    @State var opacity: Double = 0

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(TXT.launchViewTitle).font(.titleBarHeadline).foregroundColor(.highlight)

                    AttributedText(TXT.noEntriesText1)
                    HStack(alignment: .bottom) {
                        AttributedText(TXT.noEntriesText2)
                        Image(uiImage: UIImage(named: "AllowBackgroundDialog")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .clipped()
                    }
                    AttributedText(TXT.noEntriesText3)
                        .layoutPriority(100)
                        .padding(.bottom, 24)

                    HStack {
                        Spacer()
                        ActionButton(
                            image: Image(systemName: "tray.and.arrow.down.fill"),
                            caption: TXT.importDemoEntries
                        ) {
                            DispatchQueue.main.async {
                                self.waiting = true
                            }

                            RLMVisit.createEntriesFromVicinity(status: { message in
                                print("STATUS MESSAGE: \(message)")
                            }) {
                                DispatchQueue.main.async {
                                    self.waiting = false
                                    self.diary.sections.reload()
                                    self.diary.objectWillChange.send()
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.bottom, 32)
                }
                .padding(32)
                .font(.callout)
            }

            ActivityIndicatorView(isPresented: waiting, message: TXT.loadDiaryEntries)
        }
        .opacity(self.opacity)
        .onAppear {
            withAnimation(Animation.easeOut(duration: 0.3).delay(1)) {
                self.opacity = 1
            }
        }
    }
}

struct WaypointView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView()
    }
}
