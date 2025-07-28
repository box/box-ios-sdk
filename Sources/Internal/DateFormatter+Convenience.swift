import Foundation

extension DateFormatter {

     // Convenience initializer for creating a DateFormatter with a specific date format and time zone.
     // - Parameters:
     //   - dateFormat: The date format to use.
     //   - timeZone: The time zone to use. Default is GMT.
    convenience init(dateFormat: String, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.dateFormat = dateFormat
        self.timeZone = timeZone
        self.locale = Locale(identifier: "en_US_POSIX")
        self.calendar = Calendar(identifier: .iso8601)
    }
}
