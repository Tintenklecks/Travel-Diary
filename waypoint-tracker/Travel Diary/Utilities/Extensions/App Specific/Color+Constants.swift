import SwiftUI

extension UIColor {

    static var neoWhite: UIColor { UIColor(named: "NeoWhite") ?? UIColor.purple }
    static var neoWhiteLight: UIColor { UIColor(named: "NeoWhiteLight") ?? UIColor.purple }

    static var arrival: UIColor { UIColor(named: "Arrival") ?? UIColor.purple }
    static var departure: UIColor { UIColor(named: "Departure") ?? UIColor.purple }

    static var primaryText: UIColor { UIColor(named: "primaryTextColor") ?? UIColor.purple }
    static var secondaryText: UIColor { UIColor(named: "secondaryTextColor") ?? UIColor.purple }

    static var action: UIColor { UIColor(named: "actionColor") ?? UIColor.purple }
    static var actionLight: UIColor { UIColor(named: "actionColorLight") ?? UIColor.purple }
    static var actionSecondary: UIColor { UIColor(named: "actionColorSecondary") ?? UIColor.purple }
    static var actionInvers: UIColor { UIColor(named: "actionColorForeground") ?? UIColor.purple }

    static var actionBarBackground: UIColor { UIColor(named: "actionBarBackground") ?? UIColor.purple }

    static var highlight: UIColor { UIColor(named: "highlight") ?? UIColor.purple }
    static var highlightInvers: UIColor { UIColor(named: "highlightInvers") ?? UIColor.purple }

    static var info: UIColor { UIColor(named: "infoColor") ?? UIColor.purple }

    static var activityDark: UIColor { UIColor(named: "dimmedBackground") ?? UIColor.purple }
    static var activityLight: UIColor { UIColor(named: "dimmedForeground") ?? UIColor.purple }

    static var headerGradients: [UIColor] {
        [
            UIColor(named: "HeaderColor1") ?? UIColor.purple,
            UIColor(named: "HeaderColor1") ?? UIColor.purple,
            UIColor(named: "HeaderColor2") ?? UIColor.purple,
            UIColor(named: "HeaderColor3") ?? UIColor.purple,
            UIColor(named: "HeaderColor4") ?? UIColor.purple,
        ]
    }

    static var headerShadow: UIColor { UIColor(named: "HeaderShadow") ?? UIColor.purple }

    static var neoDarkShadow: UIColor { UIColor(named: "NeoDarkShadow") ?? UIColor.purple }
    static var neoLightShadow: UIColor { UIColor(named: "NeoLightShadow") ?? UIColor.purple }
    
    static var photoBorder: UIColor { UIColor(named: "photoBorder") ?? UIColor.purple }
}

extension Color {
    @Environment(\.colorScheme) static var scheme

    static var isDarkMode: Bool {
        if Color.scheme == .dark {
            return true
        } else {
            return false
        }
    }

    static let neoWhite = Color(.neoWhite)
    static let neoWhiteLight = Color(.neoWhiteLight)

    static let arrival = Color(.arrival)
    static let departure = Color(.departure)

    static let primaryText = Color(.primaryText)
    static let secondaryText = Color(.secondaryText)

    static let actionInvers = Color(.actionInvers)
    static let action = Color(.action)
    static let actionLight = Color(.actionLight)
    static let actionSecondary = Color(.actionSecondary)

    static var actionBarBackground = Color(.actionBarBackground)
    
    static let highlight = Color(.highlight)
    static let highlightInvers = Color(.highlightInvers)

    static let info = Color(.info)

    static let headerGradients = UIColor.headerGradients.map { Color($0) }
    static let headerShadow = Color(.headerShadow)

    static let neoLightShadow = Color(.neoLightShadow)
    static let neoDarkShadow = Color(.neoDarkShadow)
    
    static let photoBorder = Color(.photoBorder)
    
    static let activityDark = Color(.activityDark)
    static let activityLight = Color(.activityLight)


    
}
