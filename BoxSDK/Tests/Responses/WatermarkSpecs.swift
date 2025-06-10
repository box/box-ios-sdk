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

    override class func spec() {
        describe("Watermark") {
            describe("init()") {
                context("success case") {
                    it("should make call to init() to initialize watermark response object") {
                        guard let filepath = TestAssets.path(forResource: "FullWatermark.json") else {
                            fail("Could not find fixture file.")
                            return
                        }

                        do {
                            let contents = try String(contentsOfFile: filepath)
                            let watermarkResponseDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                            let watermarkResponse = try Watermark.WatermarkResponse(json: watermarkResponseDictionary as! [String: Any])

                            expect(watermarkResponse.watermark.createdAt?.iso8601).to(equal("2019-08-27T00:55:33Z"))
                            expect(watermarkResponse.watermark.modifiedAt?.iso8601).to(equal("2019-08-27T01:55:33Z"))
                        }
                        catch {
                            fail("Failed with Error: \(error)")
                        }
                    }
                }

                context("decoding error case when required field is missing") {
                    it("should make call to init() to initialize watermark response object") {
                        guard let filepath = TestAssets.path(forResource: "InvalidWatermarkMissing.json")
                        else {
                            fail("Could not find fixture file.")
                            return
                        }

                        do {
                            let contents = try String(contentsOfFile: filepath)
                            let watermarkResponseDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                            let expectedError: BoxSDKError = BoxCodingError(message: .typeMismatch(key: "watermark"))
                            expect(try Watermark.WatermarkResponse(json: watermarkResponseDictionary as! [String: Any])).to(throwError(expectedError))
                        }
                        catch {
                            fail("Failed with Error: \(error)")
                        }
                    }
                }

                context("decoding error case when required field is invalid type") {
                    it("should make call to init() to initialize watermark response object") {
                        guard let filepath = TestAssets.path(forResource: "InvalidWatermarkInvalid.json")
                        else {
                            fail("Could not find fixture file.")
                            return
                        }

                        do {
                            let contents = try String(contentsOfFile: filepath)
                            let watermarkResponseDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                            let expectedError: BoxSDKError = BoxCodingError(message: .invalidValueFormat(key: "created_at"))
                            expect(try Watermark.WatermarkResponse(json: watermarkResponseDictionary as! [String: Any])).to(throwError(expectedError))
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
