//

import SwiftUI

struct MainNavigationView: View {
    @EnvironmentObject var settings: AppState
    @EnvironmentObject var diary: DiaryViewModel
    @State var selectedItem = TabBarItems.diary
    @State private var waiting: Bool = false
    @State private var showWhatsNew: Bool = Settings.showWhatsNew
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    if self.selectedItem == .diary {
                        DiaryView()
                            .environmentObject(self.settings)
                            .environmentObject(self.diary)
                    } else if self.selectedItem == TabBarItems.aroundMe {
                        AroundMeView()
                            .environmentObject(self.settings)
                    } else if self.selectedItem == TabBarItems.clusterMap {
                        ClusterMap()
                            .environmentObject(self.settings)
                            .environmentObject(self.diary)
                    } else {
                        DestinationSelectionView()
                    }
                }
                .padding(.bottom, -CustomTabsView.radius)

                CustomTabsView(index: $selectedItem) {
                    DispatchQueue.main.async {
                        self.waiting = true
                        DiaryViewModel.addCurrentPosition()
                    }

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.waiting = false
                    }

                    // Get better location data and save the corrected data
                    LocationPublisher.shared.execute { _ in
                        DispatchQueue.main.async {
                            DiaryViewModel.addCurrentPosition()
                        }
                    }
                }
                .shadow(color: Color.black.opacity(0.2), radius: 0.5, x: 0, y: -1)
            }
            ActivityIndicatorView(isPresented: waiting, message: TXT.addingNewLocation)
        }
        .sheet(isPresented: $showWhatsNew) {
            OnboardingView()
        }
        .background(
            Color.neoWhite
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView()
    }
}
