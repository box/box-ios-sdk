//
//  Logger.swift
//  BoxSDK
//
//  Created by Abel Osorio on 4/17/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation
import os.log

// https://www.bignerdranch.com/blog/migrating-to-unified-logging-swift-edition/
enum LogSubsystem {
    static let boxSwiftSDK = "com.box.SwiftSDK"
}

class Logger {
    var destinations: [LogDestination]
    var category: LogCategory

    init(category: LogCategory, destinations: [LogDestination]) {
        self.category = category
        self.destinations = destinations
    }
}

// MARK: - os_log

extension Logger {
    func debug(_ message: StaticString, _ args: CVarArg...) {
        log(message, level: .debug, args)
    }

    func info(_ message: StaticString, _ args: CVarArg...) {
        log(message, level: .info, args)
    }

    func error(_ message: StaticString, _ args: CVarArg...) {
        log(message, level: .error, args)
    }

    func fatal(_ message: StaticString, _ args: CVarArg...) {
        log(message, level: .fatal, args)
    }

    func print(_ value: @autoclosure () -> Any) {
        log("%{public}@", level: .debug, [String(describing: value())])
    }

    func dump(_ value: @autoclosure () -> Any) {
        var string = String()
        Swift.dump(value(), to: &string)
        log("%{public}@", level: .debug, [string])
    }

    func trace(file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let file = URL(fileURLWithPath: String(describing: file)).deletingPathExtension().lastPathComponent
        var function = String(describing: function)
        if let firstIndex = function.firstIndex(of: "("),
            let lastIndex = function.lastIndex(of: ")") {
            function.removeSubrange(firstIndex ... lastIndex)
        }
        log("%{public}@.%{public}@():%ld", level: .debug, [file, function, line])
    }

    internal func log(_ message: StaticString, level: LogLevel, _ args: [CVarArg]) {
        destinations.forEach { $0.write(message, level: level, category: category, args) }
    }
}

// MARK: - Request Logging

extension Logger {
    func logRequest(_ request: BoxRequest) {
        var requestString = ""
        var headersString = ""
        var bodyString = ""

        let requestURL = request.endpoint()
        requestString = "▷ " + request.httpMethod.rawValue.uppercased() + " " + requestURL.absoluteString

        for (header, value) in request.httpHeaders {
            headersString += "\n    ▷ \(header), Value: \(value)"
        }

        if let body = request.bodyDescription {
            bodyString = String(data: body, encoding: .utf8) ?? ""
        }

        debug("\n\n%{public}@\n▷ Headers: %{private}@\n▷ Body: %{private}@\n", requestString, headersString, bodyString)
    }
}

// MARK: - Request Logging

extension Logger {
    func logResponse(_ response: BoxResponse) {
        var errorOutput = false
        var responseString = ""
        var headersString = ""
        var bodyString = ""

        if let unwrappedURLResponse = response.urlResponse {
            responseString = "◁ Status code: \(unwrappedURLResponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: unwrappedURLResponse.statusCode))"

            for element in unwrappedURLResponse.allHeaderFields {
                headersString += "\n    ◁ \(String(describing: element.key)), Value: \(element.value)"
            }
        }
        else {
            responseString = "◁ Empty Response"
            errorOutput = true
        }

        if let body = response.body {
            bodyString = (String(data: body, encoding: .utf8) ?? "")
        }

        let output = StaticString("\n\n%{public}@\n◁ Headers: %{private}@\n◁ Body: %{private}@\n")
        if errorOutput {
            debug(output, responseString, headersString, bodyString)
        }
        else {
            error(output, responseString, headersString, bodyString)
        }
    }
}
