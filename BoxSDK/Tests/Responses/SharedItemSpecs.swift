//
//  SharedItemSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 23/09/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class SharedItemSpecs: QuickSpec {

    override class func spec() {
        describe("Shared Item") {

            describe("init()") {

                it("should correctly deserialize a file type from full JSON representation") {
                    guard let filepath = TestAssets.path(forResource: "FullFile.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let sharedItem = try SharedItem(json: jsonDict)

                        guard case let .file(file) = sharedItem.itemValue else {
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
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should correctly deserialize a folder type from full JSON representation") {
                    guard let filepath = TestAssets.path(forResource: "FullFolder.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let sharedItem = try SharedItem(json: jsonDict)

                        guard case let .folder(folder) = sharedItem.itemValue else {
                            fail("This should be a folder")
                            return
                        }

                        expect(folder.type).to(equal("folder"))
                        expect(folder.id).to(equal("11111"))
                        expect(folder.sequenceId).to(equal("0"))
                        expect(folder.sequenceId).to(equal("0"))
                        expect(folder.etag).to(equal("0"))
                        expect(folder.name).to(equal("Test Folder"))
                        expect(folder.createdAt?.iso8601).to(equal("2013-06-01T22:52:00Z"))
                        expect(folder.modifiedAt?.iso8601).to(equal("2019-05-28T19:12:46Z"))
                        expect(folder.description).to(equal("A folder for testing"))
                        expect(folder.isCollaborationRestrictedToEnterprise).to(beTrue())
                        expect(folder.size).to(equal(814_688_861))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should correctly deserialize a webLink type from full JSON representation") {
                    guard let filepath = TestAssets.path(forResource: "FullWebLink.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let sharedItem = try SharedItem(json: jsonDict)

                        guard case let .webLink(webLink) = sharedItem.itemValue else {
                            fail("This should be a webLink")
                            return
                        }

                        expect(webLink.type).to(equal("web_link"))
                        expect(webLink.id).to(equal("11111"))
                        expect(webLink.sequenceId).to(equal("0"))
                        expect(webLink.etag).to(equal("0"))
                        expect(webLink.name).to(equal("Example Web Link"))
                        expect(webLink.url?.absoluteString).to(equal("http://example.com"))
                        expect(webLink.createdBy?.type).to(equal("user"))
                        expect(webLink.createdBy?.id).to(equal("22222"))
                        expect(webLink.createdBy?.name).to(equal("Example User"))
                        expect(webLink.createdBy?.login).to(equal("user@example.com"))
                        expect(webLink.createdAt?.iso8601).to(equal("2019-01-23T00:19:34Z"))
                        expect(webLink.modifiedAt?.iso8601).to(equal("2019-01-23T00:19:34Z"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should throw BoxCodingError.valueMismatch exception when deserialize an object with an unknown value in type filed") {
                    guard let filepath = TestAssets.path(forResource: "FullFile_ValueFormatMismatch.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let sharedItemDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                        let expectedError = BoxCodingError(message: .valueMismatch(key: "type", value: "invalid_type_value", acceptedValues: ["file", "folder", "web_link"]))
                        expect(try SharedItem(json: sharedItemDictionary as! [String: Any])).to(throwError(expectedError))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should throw BoxCodingError.typeMismatch exception when deserialize object with no type field") {
                    guard let filepath = TestAssets.path(forResource: "FullFile_MissingRequiredField.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let sharedItemDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                        let expectedError = BoxCodingError(message: .typeMismatch(key: "type"))
                        expect(try SharedItem(json: sharedItemDictionary as! [String: Any])).to(throwError(expectedError))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
