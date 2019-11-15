//
//  ConsoleLogDestination.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/10/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation
import os.log

/// Defines logging into a console
public class ConsoleLogDestination: LogDestination {
    private var sdkLogger = OSLog(subsystem: LogSubsystem.boxSwiftSDK, category: LogCategory.sdk.description)
    private var networkAgentLogger = OSLog(subsystem: LogSubsystem.boxSwiftSDK, category: LogCategory.networkAgent.description)
    private var clientLogger = OSLog(subsystem: LogSubsystem.boxSwiftSDK, category: LogCategory.client.description)
    private var modulesLogger = OSLog(subsystem: LogSubsystem.boxSwiftSDK, category: LogCategory.modules.description)

    // swiftlint:disable cyclomatic_complexity

    /// Logs a message into the console
    ///
    /// - Parameters:
    ///   - message: Message to be written into the console log
    ///   - level: Log level defining type of log
    ///   - category: Log category defining type of data logged
    ///   - args: Log arguments
    public func write(_ message: StaticString, level: LogLevel, category: LogCategory, _ args: [CVarArg]) {

        let type = level.osLogType
        var logger: OSLog
        switch category {
        case .sdk:
            logger = sdkLogger
        case .client:
            logger = clientLogger
        case .modules:
            logger = modulesLogger
        case .networkAgent:
            logger = networkAgentLogger
        }

        // The Swift overlay of os_log prevents from accepting an unbounded number of args
        // http://www.openradar.me/33203955
        // https://stackoverflow.com/questions/50937765/why-does-wrapping-os-log-cause-doubles-to-not-be-logged-correctly
        assert(args.count <= 9)
        switch args.count {
        case 9:
            os_log(message, log: logger, type: type, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8])
        case 8:
            os_log(message, log: logger, type: type, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7])
        case 7:
            os_log(message, log: logger, type: type, args[0], args[1], args[2], args[3], args[4], args[5], args[6])
        case 6:
            os_log(message, log: logger, type: type, args[0], args[1], args[2], args[3], args[4], args[5])
        case 5:
            os_log(message, log: logger, type: type, args[0], args[1], args[2], args[3], args[4])
        case 4:
            os_log(message, log: logger, type: type, args[0], args[1], args[2], args[3])
        case 3:
            os_log(message, log: logger, type: type, args[0], args[1], args[2])
        case 2:
            os_log(message, log: logger, type: type, args[0], args[1])
        case 1:
            os_log(message, log: logger, type: type, args[0])
        default:
            os_log(message, log: logger, type: type)
        }
    }

    // swiftlint:enable cyclomatic_complexity
}
