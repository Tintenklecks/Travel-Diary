//

import SwiftUI
import UIKit

extension Image {
    static let arrival = Image.coloredImage("arrival", in: .arrival)
    static let departure = Image.coloredImage("departure", in: .departure)
    static let compassArrow = Image.coloredImage("compassArrow", in: .action)
    static let compassRoseArrow = Image.coloredImage("compassRoseArrow", in: .red)
    static let compassRoseArrowInactive = Image.coloredImage("compassRoseArrow", in: .lightGray)
    

    static let compassRose =  Image.coloredImage("compassRose", in: .lightGray)
  
    
    var bigSymbol: some View {
        self.resizable().frame(width: 19, height: 19)
    }
    
    var smallSymbol: some View {
        self.resizable().frame(width: 17, height: 17)
    }

}

extension UIImage {
    static let arrival = UIImage(named: "arrival")!.withTintColor(.arrival)
    static let departure = UIImage(named: "departure")!.withTintColor(.departure)
    static let compassArrow = UIImage(named: "compassArrow")!.withTintColor(.action)
    static let compassRoseArrow = UIImage(named: "compassRoseArrow")!.withTintColor(.action)
    static let compassRose = UIImage(named: "compassRose")!  // .withTintColor(.action)

    static let distance = UIImage(named: "distance")!.withTintColor(.highlight)
    static let clock = UIImage(named: "clock")!.withTintColor(.highlight)

    
    static let bigSymbol = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
    static let smallSymbol = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular)
}

extension Font {
    static let titleBarHeadline = Font.system(size: 24, weight: .light, design: .rounded)
}
