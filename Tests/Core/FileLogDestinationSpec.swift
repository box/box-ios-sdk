//
//  FileLogDestinationSpec.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 16/09/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Foundation
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class FileLogDestinationSpec: QuickSpec {
    var fileURL: URL!
    var sut: FileLogDestination!

    override func spec() {
        describe("FileLogDestination") {

            describe("init()") {
                afterEach {
                    self.sut = nil
                    self.removeFile(fileURL: self.fileURL)
                    self.fileURL = nil
                }

                it("after init() a file at specific URL should exists") {
                    self.fileURL = self.makeFileURL()

                    self.sut = FileLogDestination(fileURL: self.fileURL)

                    expect { FileManager.default.fileExists(atPath: self.fileURL.path) }
                        .to(equal(true))
                }
            }

            describe("write()") {
                beforeEach {
                    self.fileURL = self.makeFileURL()
                    self.sut = FileLogDestination(fileURL: self.fileURL)
                }

                afterEach {
                    self.sut = nil
                    self.removeFile(fileURL: self.fileURL)
                    self.fileURL = nil
                }

                it("should write single message to a log file") {
                    self.sut.write("Log message", level: .debug, category: .client, [])
                    do {
                        let fileContent = try String(contentsOf: self.fileURL)
                        expect(fileContent).to(equal("[DEBUG] CLIENT Log message\n"))
                    }
                    catch {
                        fail("Expected to get file's content")
                        return
                    }
                }

                it("should keep order when adding logs to a file") {
                    self.sut.write("First log message", level: .error, category: .networkAgent, [])
                    self.sut.write("Second log message", level: .error, category: .networkAgent, [])
                    do {
                        let fileContent = try String(contentsOf: self.fileURL)
                        expect(fileContent).to(beginWith("[ERROR] NETWORK AGENT First log message\n"))
                        expect(fileContent).to(endWith("[ERROR] NETWORK AGENT Second log message\n"))
                    }
                    catch {
                        fail("Expected to get file's content")
                        return
                    }
                }
            }
        }
    }

    private func makeFileURL() -> URL {
        let temporaryFolderURL = URL(fileURLWithPath: NSTemporaryDirectory())
        return temporaryFolderURL.appendingPathComponent("logs.txt").absoluteURL
    }

    private func removeFile(fileURL: URL) {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            }
            catch {
                fail("Expected to remove a file")
                return
            }
        }
    }
}
