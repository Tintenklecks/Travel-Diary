 //
  
 import SwiftUI

struct StartSwitchView: View {
    @EnvironmentObject var settings: AppState
    @EnvironmentObject var diary: DiaryViewModel

    var body: some View {
        if diary.status == .loaded, settings.startAnimationDone {
            return  AnyView(MainNavigationView()
                .environmentObject(settings)
                .environmentObject(diary))
        } else {
            return
                AnyView(LaunchView()
                    .environmentObject(settings)
                    .environmentObject(diary))
        }
    }
}

struct StartSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        StartSwitchView()
    }
}
