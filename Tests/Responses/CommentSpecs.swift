//
//  CommentSpecs.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 6/7/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class CommentSpecs: QuickSpec {

    override func spec() {
        describe("Comment") {
            describe("init()") {
                context("success case") {
                    it("should make call to init() to initalize comment response object") {
                        guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullComment", ofType: "json") else {
                            fail("Could not find fixture file.")
                            return
                        }

                        do {
                            let contents = try String(contentsOfFile: filepath)
                            let commentDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                            let comment = try Comment(json: commentDictionary as! [String: Any])
                            guard let userObject = comment.createdBy else {
                                fail("No User Object Parsed.")
                                return
                            }
                            guard let itemObject = comment.item, case let .file(file) = itemObject else {
                                fail("No Item Object Parsed.")
                                return
                            }
                            expect(comment.id).to(equal("11111"))
                            expect(comment.type).to(equal("comment"))
                            expect(comment.message).to(equal("Bob, can you review this?"))
                            expect(comment.taggedMessage).to(equal("@[44444:Bob], can you review this?"))
                            expect(comment.isReplyComment).to(beFalse())
                            expect(userObject.id).to(equal("22222"))
                            expect(userObject.type).to(equal("user"))
                            expect(userObject.name).to(equal("Example User"))
                            expect(userObject.login).to(equal("user@example.com"))
                            expect(file.id).to(equal("33333"))
                            expect(file.type).to(equal("file"))
                            expect(comment.createdAt?.iso8601).to(equal("2018-06-06T02:27:23Z"))
                            expect(comment.modifiedAt?.iso8601).to(equal("2018-06-06T18:47:21Z"))
                        }
                        catch {
                            fail("Failed with Error: \(error)")
                        }
                    }
                }

                context("decoding error case when required field is missing or mismatched") {
                    it("should make call to init() to initalize comment response object") {
                        guard let filepath = Bundle(for: type(of: self)).path(forResource: "FaultyComment_MissingRequiredField", ofType: "json") else {
                            fail("Could not find fixture file.")
                            return
                        }

                        do {
                            let contents = try String(contentsOfFile: filepath)
                            let commentDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                            let expectedError: BoxSDKError = BoxCodingError(message: .typeMismatch(key: "id"))
                            expect(try Comment(json: commentDictionary as! [String: Any])).to(throwError(expectedError))
                        }
                        catch {
                            fail("Failed with Error: \(error)")
                        }
                    }
                }

                context("decoding error case when required field is missing or mismatched") {
                    it("should make call to init() to initalize comment response object") {
                        guard let filepath = Bundle(for: type(of: self)).path(forResource: "FaultyComment_ValueFormatMismatch", ofType: "json") else {
                            fail("Could not find fixture file.")
                            return
                        }

                        do {
                            let contents = try String(contentsOfFile: filepath)
                            let commentDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                            let expectedError: BoxSDKError = BoxCodingError(message: .valueMismatch(key: "created_at", value: "2018", acceptedValues: ["Comment"]))
                            expect(try Comment(json: commentDictionary as! [String: Any])).to(throwError(expectedError))
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
