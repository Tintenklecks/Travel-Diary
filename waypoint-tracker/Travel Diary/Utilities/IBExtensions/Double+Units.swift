 //
  
 import Foundation
import UIKit

public enum UnitSystem {
    case imperial
    case metric
    case nautic // never used til now

    public static var current: UnitSystem {
        if Locale.current.usesMetricSystem {
            return .metric
        }
        return .imperial
    }

    static var speedFactor: Double {
        switch UnitSystem.current {
        case .imperial:
            return 2.2369363
        case .nautic:
            return 1.94384449
        default:
            return 3.6
        }
    }

    static var speedUnit: String {
        switch UnitSystem.current {
        case imperial:
            return "mph"
        case .nautic:
            return "knots"
        default:
            return "km/h"
        }
    }

    static var smallDistanceUnitFactor: Double {
        switch UnitSystem.current {
        case .imperial:
            return 3.2808399
        case .nautic:
            return 3.2808399
        default:
            return 1.0
        }
    }

    static var smallDistanceUnit: String {
        switch UnitSystem.current {
        case .imperial:
            return "ft"
        case .nautic:
            return "ft"
        default:
            return "m"
        }
    }

    static var largeDistanceUnitFactor: Double {
        switch UnitSystem.current {
        case .imperial:
            return 0.000621371
        case .nautic:
            return 0.000539957
        default:
            return 0.001
        }
    }

    static var largeDistanceUnit: String {
        switch UnitSystem.current {
        case .imperial:
            return "mi"
        case .nautic:
            return "NM"
        default:
            return "km"
        }
    }
}

public extension Double {
    func formattedNumber(with decimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSize = 3
        formatter.currencySymbol = ""
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }

    func speed(in unit: UnitSystem = UnitSystem.current) -> Double {
        return UnitSystem.speedFactor * self
    }

    func formattedSpeed(withDecimals decimals: Int, andUnitSymbol withUnitSymbol: Bool) -> String? {
        let value = UnitSystem.speedFactor * self
        let speedString = value.formattedNumber(with: decimals)
        if withUnitSymbol {
            return "\(speedString) \(UnitSystem.speedUnit)"
        }
        return speedString
    }

    var formattedDistance: String {
        guard self >= 0 else { return "" }

        var distance: Double
        distance = self * UnitSystem.smallDistanceUnitFactor
        if distance < 1000 {
            return distance.formattedNumber(with: 0)
        }
        distance = self * UnitSystem.largeDistanceUnitFactor
        if distance < 100 {
            return distance.formattedNumber(with: 1)
        }
        return distance.formattedNumber(with: 0)
    }

    var formattedDistanceWithUnit: String {
        guard self >= 0 else { return "" }

        return "\(formattedDistance) \(formattedDistanceUnit)"
    }

    var formattedDistanceUnit: String {
        guard self >= 0 else { return "" }

        let distance = self * UnitSystem.smallDistanceUnitFactor
        if distance < 1000 {
            return UnitSystem.smallDistanceUnit
        }
        return UnitSystem.largeDistanceUnit
    }

    // And the same for altitude
    var formattedAltitude: String {
        guard self >= 0 else { return "" }

        var distance = self * UnitSystem.smallDistanceUnitFactor

        if distance < 10000 {
            return distance.formattedNumber(with: 0)
        }

        distance = self * UnitSystem.largeDistanceUnitFactor
        if distance < 100 {
            return distance.formattedNumber(with: 1)
        }
        return distance.formattedNumber(with: 0)
    }

    var formattedAltitudeUnit: String {
        guard self >= 0 else { return "" }

        let distance = self * UnitSystem.smallDistanceUnitFactor
        if distance < 10000 {
            return UnitSystem.smallDistanceUnit
        }
        return UnitSystem.largeDistanceUnit
    }

    var formattedAltitudeWithUnit: String {
        guard self >= 0 else { return "" }

        return "\(formattedAltitude) \(formattedAltitudeUnit)"
    }

    var headingString: String {
        if self <= 0 + 22.5 { return "N" }
        else if self <= 45 + 22.5 { return "NE" }
        else if self <= 90 + 22.5 { return "E" }
        else if self <= 135 + 22.5 { return "SE" }
        else if self <= 180 + 22.5 { return "S" }
        else if self <= 225 + 22.5 { return "SW" }
        else if self <= 270 + 22.5 { return "W" }
        else if self <= 315 + 22.5 { return "NW" }
        else { return "N" }
    }
}
