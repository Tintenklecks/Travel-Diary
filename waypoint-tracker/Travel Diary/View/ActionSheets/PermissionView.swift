import CoreLocation
import SwiftUI

// enum PermissionState {
//    case notYetAgreed
//    case activateInSettings
//    case agreed
// }
//
struct PermissionView: View {
    @EnvironmentObject var settings: UserSettings
    let locationManager = CLLocationManager()
    @State var permissionLocation: PermissionState = .notYetAgreed
    @State var permissionPhotos: PermissionState = .notYetAgreed
    
    var locationBlockView: some View {
        switch permissionLocation {
        case .notYetAgreed:
            return
                VStack(alignment: .leading) {
                    Text(TXT.permissionLocationNotYetAgreed)
                        .layoutPriority(100)
                    ActionButton(
                        image: Image(systemName: "hand.thumbsup.fill"),
                        caption: TXT.grantPermission) {
                        self.locationManager.requestAlwaysAuthorization()
                    }
                }
                .asAnyView()
            
        case .activateInSettings:
            return
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Image(systemName: "location.slash")
                            .frame(width: 32, height: 20)
                        
                        Text(TXT.permissionLocationActivateInSettings)
                            .layoutPriority(100)
                    }
                    ActionButton(
                        image: Image(systemName: "gear"),
                        caption: TXT.settings) {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                .asAnyView()
            
        case .agreed:
            
            return
                HStack(alignment: .top) {
                    Image(systemName: "checkmark")
                        .frame(width: 32, height: 20)
                    
                    Text(TXT.permissionAgreed)
                        .layoutPriority(100)
                }
                .asAnyView()
        }
    }
    
    var imageBlockView: some View {
        switch permissionLocation {
        case .notYetAgreed:
            return
                VStack(alignment: .leading) {
                    Text("NSPhotoLibraryUsageDescription".localized)
                        .layoutPriority(100)
                    ActionButton(
                        image: Image(systemName: "hand.thumbsup.fill"),
                        caption: TXT.grantPermission) {
                        self.locationManager.requestAlwaysAuthorization()
                    }
                }.asAnyView()
            
        case .activateInSettings:
            return
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Image(systemName: "checkmark.seal.fill")
                            .frame(width: 32, height: 20)
                        
                        Text(TXT.permissionPhotorollActivateInSettings)
                            .layoutPriority(100)
                    }
                    ActionButton(
                        image: Image(systemName: "gear"),
                        caption: TXT.settings) {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                .asAnyView()
            
        case .agreed:
            
            return
                HStack {
                    Image(systemName: "checkmark")
                        .frame(width: 32, height: 20)
                    
                    Text(TXT.permissionAgreed)
                        .layoutPriority(100)
                }
                .asAnyView()
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading) {
                    Text(TXT.location)
                        .font(.headline)
                    self.locationBlockView
                }
                .padding(24)
                
                .modifier(NeoStyleModifier(size: 2))
                
                VStack(alignment: .leading) {
                    Text(TXT.photoroll)
                        .font(.headline)
                    
                    self.imageBlockView
                }
                .padding(24)
                .modifier(NeoStyleModifier(size: 2))
                
                VStack(alignment: .leading) {
                    Text(TXT.notification)
                        .font(.headline)
                    
                    Text(TXT.notificationExplanation)
                    .layoutPriority(100)
                }
                .padding(24)
                .modifier(NeoStyleModifier(size: 2))
                
                Spacer()
                #if DEBUG
                ActionButton(
                    image: Image(systemName: "gear"),
                    caption: "XXX") {
                    db.deleteAll()
                }
                #endif
            }
            .padding()
        }
        
        .background(Color.neoWhite.edgesIgnoringSafeArea(.all))
        .onAppear {
            DispatchQueue.main.async {
                self.permissionLocation = self.settings.getLocationState()
            }
        }
    }
}

struct AllowLocationTrackingView_Previews: PreviewProvider {
    @Binding var test: Bool
    static var previews: some View {
        PermissionView()
    }
}
