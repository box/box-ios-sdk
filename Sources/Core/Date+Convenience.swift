//
//  Date+Convenience.swift
//  BoxSDK
//
//  Created by Abel Osorio on 4/12/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

extension ISO8601DateFormatter {
    // swiftlint:disable:next force_unwrapping
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601 = ISO8601DateFormatter()
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }

    init?(fromISO8601String dateValue: String) {
        guard let date = dateValue.iso8601 else {
            return nil
        }
        self = date
    }
}

extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}
