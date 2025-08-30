import CoreLocation
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var settings = AppState()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let diary: DiaryViewModel = (UIApplication.shared.delegate as! AppDelegate).diary

        setAppearance()

        db.cleanUp()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            if ProcessInfo().arguments.contains("-FASTLANE_SNAPSHOT") {
                UIView.setAnimationsEnabled(false)
            }

            if ProcessInfo().arguments.contains("DARKMODE") {
                window.overrideUserInterfaceStyle = .dark
            }

            window.rootViewController = UIHostingController(rootView:
                StartSwitchView()
                    .environmentObject(settings)
                    .environmentObject(diary))
            self.window = window

            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        AppNotification.sendReloadData()
    }

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
