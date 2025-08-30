 //
  
 import Foundation

public extension String {
    var iso8601Date: Date {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: self) {
            return date
        }

        formatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]
        if let date = formatter.date(from: self) {
            return date
        }
        
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: self) {
            return date
        }


        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return Date.distantPast
    }
    
    var dateFromSortedDateFormat: Date {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        let date = dateformat.date(from: self) ?? Date.distantPast
        return date

    }
}
