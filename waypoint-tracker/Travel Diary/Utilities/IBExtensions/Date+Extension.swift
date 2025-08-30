import Foundation

public extension Date {
    static var isDayBeforeMonth: Bool {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short

        for c in dateformatter.dateFormat {
            if c == "M" {
                return false
            } else if c == "d" {
                return true
            }
        }
        return false
    }

    // MARK: - rounded -

    var roundedToMinute: Date {
        let timeInterval = Int(self.timeIntervalSince1970)
        let roundedInterval = timeInterval - timeInterval % 60
        let newTime = Date(timeIntervalSince1970: Double(roundedInterval))
        return newTime
    }

    var roundedToTenMinutes: Date {
        let timeInterval = Int(self.timeIntervalSince1970)
        let roundedInterval = timeInterval - timeInterval % 600
        let newTime = Date(timeIntervalSince1970: Double(roundedInterval))
        return newTime
    }

    var roundedToHour: Date {
        let timeInterval = Int(self.timeIntervalSince1970)
        let roundedInterval = timeInterval - timeInterval % 3600
        let newTime = Date(timeIntervalSince1970: Double(roundedInterval))
        return newTime
    }

    var monthAndDay: String {
        if Date.isDayBeforeMonth {
            return "\(self.day(leadingZero: false)) \(self.monthText)"

        } else {
            return "\(self.monthText) \(self.day(leadingZero: false))"
        }
    }

    var monthAndDayNumeric: String {
        let endDelimiter = Date.dateDelimiter == "." ? "." : ""
        if Date.isDayBeforeMonth {
            return "\(self.day(leadingZero: false))\(Date.dateDelimiter)\(self.month(leadingZero: false))\(endDelimiter)"
        } else {
            return "\(self.month(leadingZero: false))\(Date.dateDelimiter)\(self.day(leadingZero: false))\(endDelimiter)"
        }
    }

    static var dateDelimiter: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        for c in formatter.string(from: Date()) {
            if c < "0" || c > "9" {
                return String(c) // first non numeric character
            }
        }
        return " "
    }

    var sortableDate: String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        let string = dateformat.string(from: self)
        return string
    }

    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    var longDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    var shortTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    var longTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .long
        return formatter.string(from: self)
    }

    func day(leadingZero: Bool = true) -> String {
        let day = Calendar.current.component(.day, from: self)
        if day < 10, leadingZero {
            return "0\(day)"
        } else {
            return "\(day)"
        }
    }

    func month(leadingZero: Bool = true) -> String {
        let month = Calendar.current.component(.month, from: self)
        if month < 10, leadingZero {
            return "0\(month)"
        } else {
            return "\(month)"
        }
    }

    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }

    var weekdayText: String {
        let weekday = Calendar.current.component(.weekday, from: self)
        return Locale.current.calendar.weekdaySymbols[weekday - 1]
    }

    var weekdayAbbrevation: String {
        let weekday = Calendar.current.component(.weekday, from: self)
        return Locale.current.calendar.shortWeekdaySymbols[weekday - 1]
    }

    var weekdayAbbrevationShort: String {
        let weekday = Calendar.current.component(.weekday, from: self)
        return
            String(Locale.current.calendar.shortWeekdaySymbols[weekday - 1].prefix(2))
    }

    var monthText: String {
        let month = Calendar.current.component(.month, from: self)
        return Locale.current.calendar.monthSymbols[month - 1]
    }

    var monthAbbrevation: String {
        let month = Calendar.current.component(.month, from: self)
        return Locale.current.calendar.shortMonthSymbols[month - 1]
    }

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var isCurrentYear: Bool {
        let currentYear = Calendar.current.component(.year, from: Date())
        let year = Calendar.current.component(.year, from: self)
        return year == currentYear
    }

    var isCurrentMonth: Bool {
        let current = Calendar.current.component(.month, from: Date())
        let value = Calendar.current.component(.month, from: self)
        return value == current
    }

    var isCurrentDay: Bool {
        let current = Calendar.current.component(.day, from: Date())
        let value = Calendar.current.component(.day, from: self)
        return value == current
    }

    var xsdDateTime: String { // "2020-03-29T12:42:43Z"
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: self)
    }

    var jsonDateTime: String { // 2020-03-23T07:33:22+0000
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]
        return formatter.string(from: self) + "+0000"
    }
    
    var startOfDay: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond, .timeZone], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        if let date = Calendar.current.date(from: components) {
            return date
        }
        return self
        
    }
    
    func isSameDay(date: Date) -> Bool {
        if self.startOfDay == date.startOfDay {
            return true
        }
        return false
    }
    
    static func between(date1: Date, date2: Date) -> Date {
        let midpoint = (date1.timeIntervalSince1970 + date2.timeIntervalSince1970) / 2
        return Date(timeIntervalSince1970: midpoint)
    }
    
    var isInWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    
    var isWorkday: Bool {
        return !Calendar.current.isDateInWeekend(self)
    }
    

}
