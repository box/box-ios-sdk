//
//  CommentItemSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 21/09/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class CommentItemSpecs: QuickSpec {

    override class func spec() {
        describe("Comment Item") {

            describe("init()") {

                it("should correctly deserialize a file type from full JSON representation") {
                    guard let filepath = TestAssets.path(forResource: "FullFile.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let commentItem = try CommentItem(json: jsonDict)

                        guard case let .file(file) = commentItem else {
                            fail("This should be a file")
                            return
                        }

                        expect(file.type).to(equal("file"))
                        expect(file.id).to(equal("11111"))
                        expect(file.etag).to(equal("2"))
                        expect(file.sequenceId).to(equal("2"))
                        expect(file.sha1).to(equal("14acc506f2021b2f1a9d81097ca82e14887b34fe"))
                        expect(file.name).to(equal("script.js"))
                        expect(file.extension).to(equal("js"))
                        expect(file.description).to(equal("My test script"))
                        expect(file.size).to(equal(33510))
                        expect(file.createdAt?.iso8601).to(equal("2018-02-27T18:57:08Z"))
                        expect(file.modifiedAt?.iso8601).to(equal("2018-02-27T18:57:14Z"))
                        expect(file.contentCreatedAt?.iso8601).to(equal("2017-10-09T22:09:01Z"))
                        expect(file.contentModifiedAt?.iso8601).to(equal("2017-10-09T22:09:01Z"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should correctly deserialize a comment type from full JSON representation") {
                    guard let filepath = TestAssets.path(forResource: "FullComment.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let commentItem = try CommentItem(json: jsonDict)

                        guard case let .comment(comment) = commentItem else {
                            fail("This should be a folder")
                            return
                        }

                        expect(comment.id).to(equal("11111"))
                        expect(comment.type).to(equal("comment"))
                        expect(comment.message).to(equal("Bob, can you review this?"))
                        expect(comment.taggedMessage).to(equal("@[44444:Bob], can you review this?"))
                        expect(comment.isReplyComment).to(beFalse())
                        expect(comment.createdAt?.iso8601).to(equal("2018-06-06T02:27:23Z"))
                        expect(comment.modifiedAt?.iso8601).to(equal("2018-06-06T18:47:21Z"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should throw BoxCodingError.valueMismatch exception when deserialize an object with an unknown value in `type` filed") {
                    guard let filepath = TestAssets.path(forResource: "FullFile_ValueFormatMismatch.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let commentItemDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                        let expectedError = BoxCodingError(message: .valueMismatch(key: "type", value: "invalid_type_value", acceptedValues: ["file", "comment"]))
                        expect(try CommentItem(json: commentItemDictionary as! [String: Any])).to(throwError(expectedError))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should throw BoxCodingError.typeMismatch exception when deserialize object with no `type` field") {
                    guard let filepath = TestAssets.path(forResource: "FullFile_MissingRequiredField.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let commentItemDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                        let expectedError = BoxCodingError(message: .typeMismatch(key: "type"))
                        expect(try CommentItem(json: commentItemDictionary as! [String: Any])).to(throwError(expectedError))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }

            describe("rawData") {
                it("should be equal to json data used to create the CommentItem file type object") {
                    guard let filepath = TestAssets.path(forResource: "FullFile.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let commentItem = try CommentItem(json: jsonDict)

                        expect(JSONComparer.match(json1: commentItem.rawData, json2: jsonDict)).to(equal(true))
                        expect(commentItem.json()).to(equal(commentItem.toJSONString()))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should be equal to json data used to create the CommentItem comment type object") {
                    guard let filepath = TestAssets.path(forResource: "FullComment.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let commentItem = try CommentItem(json: jsonDict)

                        expect(JSONComparer.match(json1: commentItem.rawData, json2: jsonDict)).to(equal(true))
                        expect(commentItem.json()).to(equal(commentItem.toJSONString()))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }

            describe("debugDescription") {
                it("should return correct description for a file type") {
                    guard let filepath = TestAssets.path(forResource: "FullFile.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let commentItem = try CommentItem(json: jsonDict)
                        expect(commentItem.debugDescription).to(equal("file Optional(\"script.js\")"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should return correct description for comment type") {
                    guard let filepath = TestAssets.path(forResource: "FullComment.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let commentItem = try CommentItem(json: jsonDict)

                        expect(commentItem.debugDescription).to(equal("comment 11111"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
