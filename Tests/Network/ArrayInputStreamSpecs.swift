//
//  ArrayInputStreamSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 23/09/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class ArrayInputStreamSpecs: QuickSpec {

    override class func spec() {
        var stream1: InputStream!
        var stream2: InputStream!
        var stream3: InputStream!
        var sut: ArrayInputStream!

        describe("ArrayInputStream") {
            beforeEach {
                stream1 = InputStream(data: "1".data(using: .utf8)!)
                stream2 = InputStream(data: "22".data(using: .utf8)!)
                stream3 = InputStream(data: "333".data(using: .utf8)!)
                sut = ArrayInputStream(inputStreams: [stream1, stream2, stream3])
            }

            afterEach {
                sut.close()
            }

            describe("read()") {
                it("should read all available data in ArrayInputStream if bufferSize is bigger than stream content") {
                    let bufferSize = 128
                    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
                    let readBytes = sut.read(buffer, maxLength: bufferSize)
                    expect(readBytes).to(equal(6))

                    var readData = Data()
                    readData.append(buffer, count: readBytes)
                    let readString = String(decoding: readData, as: UTF8.self)
                    expect(readString).to(equal("122333"))

                    buffer.deallocate()
                }

                it("should read 1 byte from ArrayInputStream if bufferSize is set to 1") {
                    let bufferSize = 1
                    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
                    let readBytes = sut.read(buffer, maxLength: bufferSize)
                    expect(readBytes).to(equal(1))

                    var readData = Data()
                    readData.append(buffer, count: readBytes)
                    let readString = String(decoding: readData, as: UTF8.self)
                    expect(readString).to(equal("1"))

                    buffer.deallocate()
                }

                it("should read all bytes from all inputs streams one after another until read method return 0") {
                    let bufferSize = 1
                    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
                    var readBytes = 0
                    var readData = Data()

                    repeat {
                        readBytes = sut.read(buffer, maxLength: bufferSize)
                        readData.append(buffer, count: readBytes)
                    }
                    while readBytes > 0

                    let readString = String(decoding: readData, as: UTF8.self)
                    expect(readString).to(equal("122333"))

                    buffer.deallocate()
                }
            }
        }
    }
}
