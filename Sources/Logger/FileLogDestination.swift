//
//  FileLogDestination.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/10/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation
import os.log

// swiftlint:disable:next force_unwrapping
let fileLoggerDefaultURL = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!.appendingPathComponent("BOXSDK.txt")

/// Defines logging into a file
public class FileLogDestination: LogDestination {
    private var fileURL: URL
    private var fileHandler: FileHandle?

    deinit {
        fileHandler?.closeFile()
    }

    /// Intializer.
    ///
    /// - Parameter fileURL: The file path to write the logs to.
    public init(fileURL: URL) {
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            if !FileManager.default.createFile(atPath: fileURL.path, contents: nil) {
                os_log("File for logging could not be created: %@", log: .default, type: .error, fileURL.path)
            }
        }
        self.fileURL = fileURL
        do {
            fileHandler = try FileHandle(forWritingTo: fileURL)
        }
        catch {
            os_log("Cannot write logs to specified file: %@", log: .default, type: .error, fileURL.path)
        }
    }

    /// Logs a message into a file
    ///
    /// - Parameters:
    ///   - message: Message to be written into the console log
    ///   - level: Log level defining type of log
    ///   - category: Log category defining type of data logged
    ///   - args: Log arguments
    public func write(_ message: StaticString, level: LogLevel, category: LogCategory, _ args: [CVarArg]) {
        let logMessage = FileLogDestination.formattedMessage(message: message.description, args: args)
        let log = "[\(level)] \(category) \(logMessage)\n"

        fileHandler?.seekToEndOfFile()
        // swiftlint:disable:next force_unwrapping
        fileHandler?.write(log.data(using: .utf8)!)
    }

    /* os_log logs strings with format specifiers (https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html)
     and {public} and {private} tags to the console.
     The full spec for logging with os_log can be found here: https://developer.apple.com/documentation/os/logging
     However, when logging to a file, there is no method for logging strings with {public} and {private} tags. String(format: )
     can only format strings with format specifiers. The method below implements the formatting functionality of os_log and
     returns a string to be logged to a file.
     */
    static func formattedMessage(message: String, args: [CVarArg]) -> String {
        let formatSpecifiers = ["@", "%", "d", "D", "u", "U", "x", "X", "o", "O", "f", "F", "e", "E", "g", "G", "c", "C", "s", "S", "p", "a", "A"]
        var messageCopy = Substring(message)
        var formattedMessage = ""
        var argsIndex = 0

        // While loop reads through the `message` String and adds the formatted pieces of the string to `formattedMessage`
        while let startIndex = messageCopy.firstIndex(of: "%") {
            formattedMessage += String(messageCopy[..<startIndex])
            if messageCopy.distance(from: startIndex, to: messageCopy.endIndex) > 1 {
                let index = messageCopy.index(after: startIndex)
                messageCopy = messageCopy[index...]
                var canCheckEndChar = true

                for idx in messageCopy.indices {
                    if messageCopy[idx] == "{" {
                        canCheckEndChar = false
                    }
                    else if messageCopy[idx] == "}" {
                        canCheckEndChar = true
                    }
                    else if canCheckEndChar, formatSpecifiers.contains(String(messageCopy[idx])) {
                        let endIndex: String.Index
                        if messageCopy.distance(from: idx, to: messageCopy.endIndex) == 1 {
                            endIndex = messageCopy.endIndex
                        }
                        else {
                            endIndex = messageCopy.index(after: idx)
                        }

                        if messageCopy[idx] == "%" {
                            formattedMessage += "%"
                        }
                        else {
                            var formatSpecifier = "%" + String(messageCopy[..<endIndex])
                            if formatSpecifier.contains("{public}") {
                                formatSpecifier = formatSpecifier.replacingOccurrences(of: "{public}", with: "")
                                formattedMessage += String(format: formatSpecifier, args[argsIndex])
                            }
                            else if formatSpecifier.contains("{private}") || formatSpecifier.contains("@") || formatSpecifier.contains("s") || formatSpecifier.contains("S") {
                                formattedMessage += "<private>"
                            }
                            else {
                                formattedMessage += String(format: formatSpecifier, args[argsIndex])
                            }
                            argsIndex += 1
                        }

                        messageCopy = messageCopy[endIndex...]
                        break
                    }
                }
            }
            else {
                // This is the case where there is a % at the last index of the message. To treat this case, everthing up to, but not including the % is printed
                formattedMessage += String(messageCopy[..<startIndex])
                messageCopy = ""
            }
        }
        // After the last format specifier in the `messageCopy` is found, the while loop ends.
        // So the remaining part of `messageCopy` after the last format specifier is appended to `formattedMessage`
        formattedMessage += String(messageCopy)
        return formattedMessage
    }
}
