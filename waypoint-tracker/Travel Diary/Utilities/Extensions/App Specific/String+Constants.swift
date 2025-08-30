// Accessability and Text Strings
import Foundation
import SwiftUI

enum Accessability: String {
    case empty = ""
    case arrivalTime = "TXTAccessabilityArrivalTime"
    case closeDialogButton = "TXTAccessabilityCloseDialogButton"
    case compassButton = "TXTAccessabilityCompassButton"
    case departureTime = "TXTAccessabilityDepartureTime"
    case detailsButton = "TXTAccessabilityDetailsButton"
    case diaryCell = "TXTAccessabilityDiaryCell"
    case diaryHeaderCell = "TXTAccessabilityDiaryHeaderCell"
    case diaryList = "TXTAccessabilityDiaryList"
    case distanceFromLocation = "TXTAccessabilityDistanceFromLocation"
    case durationOfStay = "TXTAccessabilityDurationOfStay"
    case editEntryButton = "TXTAccessabilityEditEntryButton"
    case entryLocation = "TXTAccessabilityEntryLocation"
    case favoriteButton = "TXTAccessabilityFavoriteButton"
    case geoLatitude = "TXTAccessabilityGeoLatitude"
    case geoLongitude = "TXTAccessabilityGeoLongitude"
    case openInMapsButton = "TXTAccessabilityOpenInMapsButton"
    case openInNavigation = "TXTAccessabilityOpenInNavigation"
    case saveEntryButton = "TXTAccessabilitySaveEntryButton"
    case showFavorite = "TXTAccessabilityShowFavorite"
    case tabBarAroundme = "TXTAccessabilityTabBarAroundme"
    case tabBarHome = "TXTAccessabilityTabBarHome"
    case tabBarMap = "TXTAccessabilityTabBarMap"
    case tabBarPlus = "TXTAccessabilityTabBarPlus"
    case tabBarSettings = "TXTAccessabilityTabBarSettings"
    case tabBarCompass = "TXTAccessabilityTabBarCompass"
    case toggleLayout = "TXTAccessabilityToggleLayout"
    case togglePictures = "TXTAccessabilityTogglePictures"
    case clearTextField = "TXTAccessabilityClearTextField"
    case hideKeyboard = "TXTAccessabilityHideKeyboard"


    var id: String {
        switch self {
        case .openInNavigation:
            return "openInNavigation"
        default:
            return self.normalized
        }
    }

    var label: String {
        return self.rawValue.localized
    }

    func label(with parameter: String) -> String {
        return self.label(with: [parameter])
    }

    func label(with parameters: [String]) -> String {
        switch parameters.count {
        case 1: return String(format: self.rawValue, parameters[0])
        case 2: return String(format: self.rawValue, parameters[0], parameters[1])
        case 3: return String(format: self.rawValue, parameters[0], parameters[1], parameters[2])
        case 4: return String(format: self.rawValue, parameters[0], parameters[1], parameters[2], parameters[3])
        case 5: return String(format: self.rawValue, parameters[0], parameters[1], parameters[2], parameters[3], parameters[4])
        case 6: return String(format: self.rawValue, parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5])
        case 7: return String(format: self.rawValue, parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6])
        default: return self.label
        }
    }

    var normalized: String {
        return self.rawValue.uppercased().filter { character -> Bool in
            character >= "A" && character <= "Z"
        }
    }
}

extension UIView {
    func setAccessability(_ type: Accessability) {
        self.accessibilityIdentifier = type.id
        self.accessibilityLabel = type.label
    }

    func setAccessability(_ type: Accessability, with parameter: [String]) {
        self.accessibilityIdentifier = type.id
        self.accessibilityLabel = type.label(with: parameter)
    }

    func setAccessability(_ type: Accessability, with parameter: String) {
        self.accessibilityIdentifier = type.id
        self.accessibilityLabel = type.label(with: parameter)
    }
}

extension View {
    func setAccessability(_ type: Accessability) -> some View {
        return self
            .accessibility(identifier: type.id)
            .accessibility(label: Text(type.label))
    }

    func setAccessability(_ type: Accessability, with parameter: String) -> some View {
        return self
            .accessibility(identifier: type.id)
            .accessibility(label: Text(type.label(with: parameter)))
    }

    func setAccessability(_ type: Accessability, with parameter: [String]) -> some View {
        return self
            .accessibility(identifier: type.id)
            .accessibility(label: Text(type.label(with: parameter)))
    }
}
