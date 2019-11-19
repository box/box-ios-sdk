//
//  WatermarkSpecs.swift
//  BoxSDK
//
//  Created by Albert Wu on 8/29/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class WatermarkSpecs: QuickSpec {

    override func spec() {
        describe("Watermark") {
            describe("init()") {
                context("success case") {
                    it("should make call to init() to initialize watermark response object") {
                        guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullWatermark", ofType: "json") else {
                            fail("Could not find fixture file.")
                            return
                        }

                        do {
                            let contents = try String(contentsOfFile: filepath)
                            let watermarkDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                            let watermark = try Watermark(json: watermarkDictionary as! [String: Any])

                            expect(watermark.createdAt?.iso8601).to(equal("2019-08-27T00:55:33Z"))
                            expect(watermark.modifiedAt?.iso8601).to(equal("2019-08-27T01:55:33Z"))
                        }
                        catch {
                            fail("Failed with Error: \(error)")
                        }
                    }
                }

                context("decoding error case when required field is missing") {
                    it("should make call to init() to initialize watermark response object") {
                        guard let filepath = Bundle(for: type(of: self)).path(forResource: "InvalidWatermarkMissing", ofType: "json")
                        else {
                            fail("Could not find fixture file.")
                            return
                        }

                        do {
                            let contents = try String(contentsOfFile: filepath)
                            let watermarkDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                            let expectedError: BoxError = BoxError.decoding(error: BoxDecodingError.typeMismatch(key: "watermark", expectedType: [String: Any].self))
                            expect(try Watermark(json: watermarkDictionary as! [String: Any])).to(throwError(expectedError))
                        }
                        catch {
                            fail("Failed with Error: \(error)")
                        }
                    }
                }

                context("decoding error case when required field is invalid type") {
                    it("should make call to init() to initialize watermark response object") {
                        guard let filepath = Bundle(for: type(of: self)).path(forResource: "InvalidWatermarkInvalid", ofType: "json")
                        else {
                            fail("Could not find fixture file.")
                            return
                        }

                        do {
                            let contents = try String(contentsOfFile: filepath)
                            let watermarkDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                            let expectedError: BoxError = BoxError.decoding(error: BoxDecodingError.invalidValueFormat(key: "created_at", value: "2019-08-26", expectedType: Date.self))
                            expect(try Watermark(json: watermarkDictionary as! [String: Any])).to(throwError(expectedError))
                        }
                        catch {
                            fail("Failed with Error: \(error)")
                        }
                    }
                }
            }
        }
    }
}
