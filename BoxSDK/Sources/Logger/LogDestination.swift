//
//  LogDestination.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/3/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
    import os.log
#endif

/// Defines main log destination behaviour
public protocol LogDestination {
    /// Logs a message
    func write(_: StaticString, level: LogLevel, category: LogCategory, _: [CVarArg])
    // swiftlint:disable:previous unused_param
}

/// Defines character of the log and when it will be displayed
public enum LogLevel: String {
    /// Logging only while debugging
    case debug
    /// Logging info message
    case info
    /// Logging error
    case error
    /// Logging fatal error
    case fatal

    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        var osLogType: OSLogType {
            switch self {
            case .debug:
                return OSLogType.debug
            case .info:
                return OSLogType.info
            case .error:
                return OSLogType.error
            case .fatal:
                return OSLogType.fault
            }
        }
    #endif
}

extension LogLevel: CustomStringConvertible {
    /// Log level string title
    public var description: String {
        return rawValue.uppercased()
    }
}

/// Defines log category based on what kind of data is being logged
public enum LogCategory: String {
    /// NetworkAgent related log
    case networkAgent = "Network Agent"
    /// Module related log
    case modules = "Modules"
    /// BoxCLient related log
    case client = "Client"
    /// The general log for BoxSDK
    case sdk = "Box SDK"
}

extension LogCategory: CustomStringConvertible {
    /// Log category string title
    public var description: String {
        return rawValue.uppercased()
    }
}
