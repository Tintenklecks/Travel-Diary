//

import Combine
#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif
import UIKit

@UIApplicationMain

/// Application LifeCycle
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var diary = DiaryViewModel()
    var reloadWatchListener: AnyCancellable?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if canImport(GoogleMobileAds)
        GADMobileAds.sharedInstance().start { status in
            for adapter in status.adapterStatusesByClassName {
                print(adapter.key, adapter.value)
            }
        }
        #endif


        #if targetEnvironment(simulator)
            db.deleteAll()
            if Fastlane.isScreenshotMode {
                Settings.showPictures = false
                Settings.cellStyle = .detailed
            }
        #endif

        db.importDefault() // Check for JSON files in the home folder

        if WatchManager.shared.session != nil {
            self.reloadWatchListener = NotificationCenter.default.publisher(for: AppNotification.reloadData)
                .sink { _ in
                    WatchManager.shared.sendRequest(endpoint: "reloadData", parameter: [:])
                }
        }

        Settings.numberOfStarts += 1
        /// Track **Visits**
        LocationPublisher.shared.visit = { [weak self] visit in

            UIApplication.shared.applicationIconBadgeNumber += 1

            if let self = self {
                self.diary.add(visit: visit)
            } else {
                RLMVisit.add(visit: visit)
            }
        }

        /// Track **MARGINAL location changes **
        LocationPublisher.shared.location = { location in
            RLMLocation.add(location)

            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.badge]

            center.requestAuthorization(options: options) {
                granted, _ in
                if !granted {
                    print("LOCATIONMANAGER Authorisation not granted")
                }
            }
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}
}
