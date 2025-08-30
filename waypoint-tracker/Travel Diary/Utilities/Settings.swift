import CoreLocation
import Foundation

enum CellStyle: Int {
    case compact = 0
    case detailed = 1
    
    var cellId: String {
        switch self {
        case .compact: return "compact"
        case .detailed: return "detailed"
        }
    }
}

class Settings {
    // MARK: - Setting properties -
    
    static let groupId = "group.de.IBMobile.Travel-Diary"
    
    static var numberOfStarts: Int {
        get {
            return Settings.getInt("numberOfStarts", defaultValue: 0)
        }
        set {
            Settings.setInt("numberOfStarts", value: newValue)
        }
    }
    
    static var showReview: Bool {
        if Settings.numberOfStarts > 20, Settings.numberOfStarts % 10 == 9 {
            return true
        }
        return false
    }
    
    static var mapStyle: MapStyle {
        get {
            return MapStyle.from(value: Settings.getInt("mapStyle", defaultValue: 0))
        }
        set {
            Settings.setInt("mapStyle", value: newValue.rawValue)
        }
    }
    
    static var isScreenshotMode: Bool {
        if UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
            return true
        }
        return false
    }
    
    static var showPictures: Bool {
        get {
            return Settings.getBool("showPictures", defaultValue: false)
        }
        set {
            Settings.setBool("showPictures", value: newValue)
        }
    }
    
    static var lastSavedVersion: String {
        get {
            return Settings.getString("lastSavedVersion", defaultValue: "")
        }
        set {
            Settings.setString("lastSavedVersion", value: newValue)
        }
    }
    
    static var showWhatsNew: Bool {
        get {
            #if os(iOS)
            if Fastlane.isScreenshotMode {
                return false
            }
            
            #endif
         
            if ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil {
                return false
            }

            if let show = UserDefaults.standard.object(forKey: "showWhatsNew") as? Bool {
                if !show {
                    if Settings.version.prefix(8) != Settings.lastSavedVersion.prefix(8) {
                        return true
                    }
                }
                return show
            } else {
                return true
            }
        }
        set {
            Settings.setBool("showWhatsNew", value: newValue)
            if !newValue {
                Settings.lastSavedVersion = Settings.version
            }
        }
    }
    
    /// Watch Settings
    
    static var complicationAction: String {
        get {
            let age = Int(Date().timeIntervalSince1970) - Settings.getInt("ComplicationActionTimestamp")
            if let action = UserDefaults.standard.object(forKey: "ComplicationAction") as? String,
                age < 5 {
                return action
            } else {
                return ""
            }
        }
        set {
            Settings.setString("ComplicationActionTimestamp", value: newValue)
            Settings.setInt("ComplicationActionTimestamp", value: Int(Date().timeIntervalSince1970))
        }
    }
    
    /// Location State
    
    static var startAnimationFinished: Bool = false
    
    static var version: String {
        if let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            #if DEBUG
            return "\(versionNumber).\(buildNumber) (\(Settings.numberOfStarts)) "
            #else
            return "\(versionNumber)"
            #endif
        }
        return "n.a."
    }
}

extension Settings {
    // MARK: - global usersetting convenience funcs -
    
    static func getInt(_ key: String, defaultValue: Int = 0) -> Int {
        if UserDefaults.standard.object(forKey: key) != nil {
            let returnValue = UserDefaults.standard.object(forKey: key) as! Int
            return returnValue
        } else {
            return defaultValue // default value
        }
    }
    
    static func getDouble(_ key: String, defaultValue: Double = 0.0) -> Double {
        if UserDefaults.standard.object(forKey: key) != nil {
            let returnValue = UserDefaults.standard.object(forKey: key) as! Double
            return returnValue
        } else {
            return defaultValue // default value
        }
    }
    
    static func getBool(_ key: String, defaultValue: Bool = false) -> Bool {
        if UserDefaults.standard.object(forKey: key) != nil {
            let returnValue = UserDefaults.standard.object(forKey: key) as! Bool
            return returnValue
        } else {
            return defaultValue // default value
        }
    }
    
    static func getString(_ key: String, defaultValue: String = "") -> String {
        if UserDefaults.standard.object(forKey: key) != nil {
            let returnValue = UserDefaults.standard.object(forKey: key) as! String
            return returnValue
        } else {
            return defaultValue // default value
        }
    }
    
    static func setInt(_ key: String, value: Int) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func setDouble(_ key: String, value: Double) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func setBool(_ key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func setString(_ key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
