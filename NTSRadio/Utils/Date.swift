//
//  Date.swift
//  NTSRadio
//
//  Created by Артмеий Шлесберг on 18/03/2018.
//  Copyright © 2018 Shlesberg. All rights reserved.
//

import Foundation

public extension Date {
    public static var sharedCalendar = NSCalendar.autoupdatingCurrent
    /// Returns instance's year component
    public var year: Int { return Date.sharedCalendar.component(.year, from: self) }
    /// Returns instance's month component
    public var month: Int { return Date.sharedCalendar.component(.month, from: self) }
    /// Returns instance's day component
    public var day: Int { return Date.sharedCalendar.component(.day, from: self) }
    /// Returns instance's hour component
    public var hour: Int { return Date.sharedCalendar.component(.hour, from: self) }
    /// Returns instance's minute component
    public var minute: Int { return Date.sharedCalendar.component(.minute, from: self) }
    /// Returns instance's second component
    public var second: Int { return Date.sharedCalendar.component(.second, from: self) }
    
    /// Returns instance's weekday component
    public var weekday: Int { return Date.sharedCalendar.component(.weekday, from: self) }
    /// Returns instance's weekdayOrdinal component
    public var weekdayOrdinal: Int { return Date.sharedCalendar.component(.weekdayOrdinal, from: self) }
    /// Returns instance's weekOfMonth component
    public var weekOfMonth: Int { return Date.sharedCalendar.component(.weekOfMonth, from: self) }
    /// Returns instance's weekOfYear component
    public var weekOfYear: Int { return Date.sharedCalendar.component(.weekOfYear, from: self) }
    
    /// Returns instance's yearForWeekOfYear component
    public var yearForWeekOfYear: Int { return Date.sharedCalendar.component(.yearForWeekOfYear, from: self) }
    
    /// Returns instance's quarter component
    public var quarter: Int { return Date.sharedCalendar.component(.quarter, from: self) }
    
    /// Returns instance's nanosecond component
    public var nanosecond: Int { return Date.sharedCalendar.component(.nanosecond, from: self) }
    /// Returns instance's (meaningless) era component
    public var era: Int { return Date.sharedCalendar.component(.era, from: self) }
    /// Returns instance's (meaningless) calendar component
    public var calendar: Int { return Date.sharedCalendar.component(.calendar, from: self) }
    /// Returns instance's (meaningless) timeZone component.
    public var timeZone: Int { return Date.sharedCalendar.component(.timeZone, from: self) }
}

// Formatters and Strings
public extension Date {
    /// Returns an ISO 8601 formatter
    public static var iso8601Formatter: DateFormatter = {
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        $0.locale = Locale(identifier: "en_US_POSIX")
        return $0 }(DateFormatter())
    /// Returns a short style date formatter
    public static var shortDateFormatter: DateFormatter = { $0.dateStyle = .short; return $0 }(DateFormatter())
    /// Returns a medium style date formatter
    public static var mediumDateFormatter: DateFormatter = { $0.dateStyle = .medium; return $0 }(DateFormatter())
    /// Returns a long style date formatter
    public static var longDateFormatter: DateFormatter = { $0.dateStyle = .long; return $0 }(DateFormatter())
    /// Returns a full style date formatter
    public static var fullDateFormatter: DateFormatter = { $0.dateStyle = .full; return $0 }(DateFormatter())
    /// Returns a short style time formatter
    public static var shortTimeFormatter: DateFormatter = { $0.timeStyle = .short; return $0 }(DateFormatter())
    /// Returns a medium style time formatter
    public static var mediumTimeFormatter: DateFormatter = { $0.timeStyle = .medium; return $0 }(DateFormatter())
    /// Returns a long style time formatter
    public static var longTimeFormatter: DateFormatter = { $0.timeStyle = .long; return $0 }(DateFormatter())
    /// Returns a full style time formatter
    public static var fullTimeFormatter: DateFormatter = { $0.timeStyle = .full; return $0 }(DateFormatter())
    
    /// Represents date as ISO8601 string
    public var iso8601String: String { return Date.iso8601Formatter.string(from: self) }
    
    /// Returns date components as short string
    public var shortDateString: String { return Date.shortDateFormatter.string(from:self) }
    /// Returns date components as medium string
    public var mediumDateString: String { return Date.mediumDateFormatter.string(from:self) }
    /// Returns date components as long string
    public var longDateString: String { return Date.longDateFormatter.string(from:self) }
    /// Returns date components as full string
    public var fullDateString: String { return Date.fullDateFormatter.string(from:self) }
    
    /// Returns time components as short string
    public var shortTimeString: String { return Date.shortTimeFormatter.string(from:self) }
    /// Returns time components as medium string
    public var mediumTimeString: String { return Date.mediumTimeFormatter.string(from:self) }
    /// Returns time components as long string
    public var longTimeString: String { return Date.longTimeFormatter.string(from:self) }
    /// Returns time components as full string
    public var fullTimeString: String { return Date.fullTimeFormatter.string(from:self) }
    
    /// Returns date and time components as short string
    public var shortString: String { return "\(self.shortDateString) \(self.shortTimeString)" }
    /// Returns date and time components as medium string
    public var mediumString: String { return "\(self.mediumDateString) \(self.mediumTimeString)" }
    /// Returns date and time components as long string
    public var longString: String { return "\(self.longDateString) \(self.longTimeString)" }
    /// Returns date and time components as full string
    public var fullString: String { return "\(self.fullDateString) \(self.fullTimeString)" }

    static func from(fullString: String) -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.date(from: fullString)
    }

}
