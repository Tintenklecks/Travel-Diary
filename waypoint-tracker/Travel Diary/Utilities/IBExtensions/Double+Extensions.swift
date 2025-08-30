//

import Foundation

public extension Double {
    init(sign: Int, degree: Int, minute: Int, second: Int) {
        self.init()
        let result = Double(degree * 3600 + minute * 60 + second) / 3600
        self = result * Double(sign)
    }
    
    var degree: (Int, Int, Int, Int) {
        let sign: Int = self < 0 ? -1 : 1
        var rest: Int = Int((abs(self) * 3600).rounded())
        let seconds = rest % 60
        rest = rest / 60
        let minutes = rest % 60
        rest = rest / 60
        
        return (sign, rest, minutes, seconds)
    }
    
    var latitudeString: String {
        let (sign, degrees, minutes, seconds) = self.degree
        let ns = sign == 1 ? "N" : "S"
        return "\(degrees)\(ns)\(minutes)'\(seconds)\""
    }
    
    var longitudeString: String {
        let (sign, degrees, minutes, seconds) = self.degree
        let ew = sign == 1 ? "E" : "W"
        return "\(degrees)\(ew)\(minutes)'\(seconds)\""
    }
    
    func timeString(withSeconds: Bool = false, condensed: Bool = false) -> String {
        var number = Int(self)
        var result = ""
        if number > 3600 * 24 { // days
            result += "\(Int(number / (3600 * 24)))d "
            number = number % (3600 * 24)
        }
        
        if number > 3600 { // hours
            result += "\(Int(number / 3600))h "
            number = number % 3600
        }
        
        let longForm = result == ""
        
        result += "\(Int(number / 60))\(longForm ? " min" : "m")"
        number = number % 60
        
        if withSeconds {
            result += " \(number)\(longForm ? " sec" : "s")"
        }
        if condensed {
            result = result.replacingOccurrences(of: " ", with: "")
            if result.count > 3 {
                result.removeLast()
            }
        }
        return result
    }
    
    func string(digits: Int, exact: Bool = false) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = exact ? digits : 0
        formatter.maximumFractionDigits = digits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    var roundedToSecondsString: String {
        self.roundLatitude.string(digits: 5)
    }
    
    var roundedToSecond: Double {
        let factor: Double = 3600
        return (self * factor).rounded() / factor
    }
    
    var roundLatitude: Double { self.roundedToSecond }
    var roundLongitude: Double { self.roundedToSecond }
}
