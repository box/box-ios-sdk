//
//  BoxModelSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Martina Stremenova on 19/07/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

@testable import BoxSDK
import Nimble
import Quick

class BoxModelSpecs: QuickSpec {
    override class func spec() {
        describe("testing boxmodel on comment") {
            it("should make call to init() to initalize comment response object from JSON dictionary") {
                guard let filepath = TestAssets.path(forResource: "FullComment.json") else {
                    fail("Could not find fixture file.")
                    return
                }

                do {
                    let contents = try String(contentsOfFile: filepath)
                    guard let data = contents.data(using: .utf8) else {
                        fail("Could not get spec file data")
                        return
                    }
                    guard let commentDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        fail("Could not create dictionary from data")
                        return
                    }

                    let comment = try Comment(json: commentDictionary)

                    expect(JSONComparer.match(json1: comment.rawData, json2: commentDictionary)).to(equal(true))
                    expect(comment.json()).to(equal(comment.toJSONString()))

                    guard let jsonString = String(data: data, encoding: .utf8) else {
                        fail("Could not create json string from data")
                        return
                    }

                    expect(JSONComparer.match(json1String: jsonString, json2String: comment.json())).to(equal(true))
                }
                catch {
                    fail("Failed with Error: \(error)")
                }
            }

            it("should make call to init() to initalize comment response object from JSON Data") {
                guard let filepath = TestAssets.path(forResource: "FullComment.json") else {
                    fail("Could not find fixture file.")
                    return
                }

                do {
                    let contents = try String(contentsOfFile: filepath)
                    guard let data = contents.data(using: .utf8) else {
                        fail("Could not get spec file data")
                        return
                    }

                    guard let commentDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        fail("Could not create dictionary from data")
                        return
                    }

                    let comment = try Comment(json: data)

                    expect(JSONComparer.match(json1: comment.rawData, json2: commentDictionary)).to(equal(true))
                    expect(comment.json()).to(equal(comment.toJSONString()))

                    guard let jsonString = String(data: data, encoding: .utf8) else {
                        fail("Could not create json string from data")
                        return
                    }

                    expect(JSONComparer.match(json1String: jsonString, json2String: comment.json())).to(equal(true))
                }
                catch {
                    fail("Failed with Error: \(error)")
                }
            }

            it("should throw an exception when call init() with invalid JSON Data object structure") {
                guard let data = "[1, 2, 3]".data(using: .utf8) else {
                    fail("Could not get spec file data")
                    return
                }

                expect { try Comment(json: data) }.to(throwError(errorType: BoxAPIError.self))
            }
        }
    }
}
