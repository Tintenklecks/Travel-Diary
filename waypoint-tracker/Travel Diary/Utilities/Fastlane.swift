import Foundation

class Fastlane {
    static let isScreenshotMode: Bool = UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT")

}
