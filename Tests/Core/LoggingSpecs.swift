//
//  LoggingSpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 11/5/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Foundation
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class LoggingSpecs: QuickSpec {
    override func spec() {
        describe("Logging") {

            describe("formattedMessage()") {
                /* Should replicate the log formatting specified here: https://developer.apple.com/documentation/os/logging
                 Format specifiers used within logging:
                 https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html */

                it("should format message with public tags") {
                    let message = FileLogDestination.formattedMessage(message: "Request %{public}@ once", args: ["failed"])
                    expect(message).to(equal("Request failed once"))
                }

                it("should format message with private tags") {
                    let message = FileLogDestination.formattedMessage(message: "Request %{private}@ once", args: ["failed"])
                    expect(message).to(equal("Request <private> once"))
                }

                it("should format message with %@ specifier set as private without tags") {
                    let message = FileLogDestination.formattedMessage(message: "Request %@ once", args: ["failed"])
                    expect(message).to(equal("Request <private> once"))
                }

                it("should format message with %s specifier set as private without tags") {
                    let message = FileLogDestination.formattedMessage(message: "Request %s once", args: ["failed"])
                    expect(message).to(equal("Request <private> once"))
                }

                it("should format message with %S specifier set as private without tags") {
                    let message = FileLogDestination.formattedMessage(message: "Request %s once", args: ["failed"])
                    expect(message).to(equal("Request <private> once"))
                }

                it("should format message with all remaining format specifiers as public without tags") {
                    let message1 = FileLogDestination.formattedMessage(message: "Log test %d", args: [7])
                    let message2 = FileLogDestination.formattedMessage(message: "Log test %D", args: [7])
                    let message3 = FileLogDestination.formattedMessage(message: "Log test %u", args: [7])
                    let message4 = FileLogDestination.formattedMessage(message: "Log test %U", args: [7])
                    let message5 = FileLogDestination.formattedMessage(message: "Log test %x", args: [10])
                    let message6 = FileLogDestination.formattedMessage(message: "Log test %X", args: [10])
                    let message7 = FileLogDestination.formattedMessage(message: "Log test %o", args: [8])
                    let message8 = FileLogDestination.formattedMessage(message: "Log test %O", args: [8])
                    let message9 = FileLogDestination.formattedMessage(message: "Log test %.03f", args: [7.700])
                    let message10 = FileLogDestination.formattedMessage(message: "Log test %F", args: [7.7])
                    let message11 = FileLogDestination.formattedMessage(message: "Log test %e", args: [7.7])
                    let message12 = FileLogDestination.formattedMessage(message: "Log test %E", args: [7.7])
                    let message13 = FileLogDestination.formattedMessage(message: "Log test %g", args: [10.0])
                    let message14 = FileLogDestination.formattedMessage(message: "Log test %G", args: [10.0])
                    let message15 = FileLogDestination.formattedMessage(message: "Log test %c", args: ["a".utf8.first!])
                    let message16 = FileLogDestination.formattedMessage(message: "Log test %C", args: ["b".utf16.first!])
                    let message17 = FileLogDestination.formattedMessage(message: "Log test %a", args: [1.5])
                    let message18 = FileLogDestination.formattedMessage(message: "Log test %A", args: [1.5])

                    expect(message1).to(equal("Log test 7"))
                    expect(message2).to(equal("Log test 7"))
                    expect(message3).to(equal("Log test 7"))
                    expect(message4).to(equal("Log test 7"))
                    expect(message5).to(equal("Log test a"))
                    expect(message6).to(equal("Log test A"))
                    expect(message7).to(equal("Log test 10"))
                    expect(message8).to(equal("Log test 10"))
                    expect(message9).to(equal("Log test 7.700"))
                    expect(message10).to(equal("Log test 7.700000"))
                    expect(message11).to(equal("Log test 7.700000e+00"))
                    expect(message12).to(equal("Log test 7.700000E+00"))
                    expect(message13).to(equal("Log test 10"))
                    expect(message14).to(equal("Log test 10"))
                    expect(message15).to(equal("Log test a"))
                    expect(message16).to(equal("Log test b"))
                    expect(message17).to(equal("Log test 0x1.8p+0"))
                    expect(message18).to(equal("Log test 0X1.8P+0"))
                }
            }
        }
    }
}
