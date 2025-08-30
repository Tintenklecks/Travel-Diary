import Foundation

public extension String {
    
    /// Unicode flag symbol
    var flag: String {
        let base: UInt32 = 127397
        var s = ""
        for v in self.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }

    static func flag(from country: String) -> String {
        return country.flag
    }
}
