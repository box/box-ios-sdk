//
//  CollaborationItemSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 17/09/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class CollaborationItemSpecs: QuickSpec {

    override func spec() {
        describe("Collaboration Item") {

            describe("init()") {

                it("should correctly deserialize a file from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullCollaborationItemFile", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let collaborationItem = try CollaborationItem(json: jsonDict)

                        guard case let .file(file) = collaborationItem else {
                            fail("This should be a file")
                            return
                        }

                        expect(file.type).to(equal("file"))
                        expect(file.id).to(equal("12345"))
                        expect(file.etag).to(equal("0"))
                        expect(file.sequenceId).to(equal("0"))
                        expect(file.sha1).to(equal("85136C79CBF9FE36BB9D05D0639C70C265C18D37"))
                        expect(file.name).to(equal("File1.pdf"))
                        expect(file.description).to(equal("Test description"))
                        expect(file.size).to(equal(629_644))

                        guard let pathCollection = file.pathCollection else {
                            fail("Expected path collection to be present")
                            return
                        }
                        expect(pathCollection.totalCount).to(equal(1))
                        expect(pathCollection.entries?.count).to(equal(1))
                        expect(pathCollection.entries?[0]).toNot(beNil())
                        expect(pathCollection.entries?[0].type).to(equal("folder"))
                        expect(pathCollection.entries?[0].id).to(equal("12345"))
                        expect(pathCollection.entries?[0].sequenceId).to(equal("3"))
                        expect(pathCollection.entries?[0].etag).to(equal("1"))
                        expect(pathCollection.entries?[0].name).to(equal("All Files"))
                        expect(file.createdAt?.iso8601).to(equal("2012-12-12T18:53:43Z"))
                        expect(file.modifiedAt?.iso8601).to(equal("2012-12-12T18:53:43Z"))
                        expect(file.contentCreatedAt?.iso8601).to(equal("2012-12-12T18:53:43Z"))
                        expect(file.contentModifiedAt?.iso8601).to(equal("2012-12-12T18:53:43Z"))
                        expect(file.parent?.type).to(equal("folder"))
                        expect(file.parent?.id).to(equal("12345"))
                        expect(file.parent?.sequenceId).to(equal("3"))
                        expect(file.parent?.etag).to(equal("1"))
                        expect(file.parent?.name).to(equal("Test Folder"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should correctly deserialize a folder from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullCollaborationItemFolder", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let collaborationItem = try CollaborationItem(json: jsonDict)

                        guard case let .folder(folder) = collaborationItem else {
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
                        expect(folder.pathCollection?.totalCount).to(equal(1))
                        expect(folder.pathCollection?.entries?.count).to(equal(1))
                        expect(folder.pathCollection?.entries?[0].type).to(equal("folder"))
                        expect(folder.pathCollection?.entries?[0].id).to(equal("0"))
                        expect(folder.pathCollection?.entries?[0].sequenceId).to(beNil())
                        expect(folder.pathCollection?.entries?[0].etag).to(beNil())
                        expect(folder.pathCollection?.entries?[0].name).to(equal("All Files"))
                        expect(folder.folderUploadEmail?.access).to(equal("collaborators"))
                        expect(folder.folderUploadEmail?.email).to(equal("Test_Fo.sidu576dbfn@u.box.com"))
                        expect(folder.parent?.type).to(equal("folder"))
                        expect(folder.parent?.id).to(equal("0"))
                        expect(folder.parent?.sequenceId).to(beNil())
                        expect(folder.parent?.etag).to(beNil())
                        expect(folder.parent?.name).to(equal("All Files"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should throw BoxCodingError.valueMismatch exception when deserialize an object with an unknown value in type filed") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullCollaborationItem_ValueFormatMismatch", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let collaborationItemDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                        let expectedError = BoxCodingError(message: .valueMismatch(key: "type", value: "invalid_type_value", acceptedValues: ["folder", "file"]))
                        expect(try CollaborationItem(json: collaborationItemDictionary as! [String: Any])).to(throwError(expectedError))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should throw BoxCodingError.typeMismatch exception when deserialize object with no type field") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullCollaborationItem_MissingRequiredField", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let collaborationItemDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                        let expectedError = BoxCodingError(message: .typeMismatch(key: "type"))
                        expect(try CollaborationItem(json: collaborationItemDictionary as! [String: Any])).to(throwError(expectedError))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }

            describe("rawData") {
                it("should be equal to json data used to create the CollaborationItem file type object") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullCollaborationItemFile", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let collaborationItem = try CollaborationItem(json: jsonDict)

                        expect(JSONComparer.match(json1: collaborationItem.rawData, json2: jsonDict)).to(equal(true))
                        expect(collaborationItem.json()).to(equal(collaborationItem.toJSONString()))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should be equal to json data used to create the CollaborationItem folder type object") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullCollaborationItemFolder", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let collaborationItem = try CollaborationItem(json: jsonDict)

                        expect(JSONComparer.match(json1: collaborationItem.rawData, json2: jsonDict)).to(equal(true))
                        expect(collaborationItem.json()).to(equal(collaborationItem.toJSONString()))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }

            describe("debugDescription") {
                it("should return correct description for a file type") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullCollaborationItemFile", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let collaborationItem = try CollaborationItem(json: jsonDict)
                        expect(collaborationItem.debugDescription).to(equal("file Optional(\"File1.pdf\")"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }

                it("should return correct description for folder type") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullCollaborationItemFolder", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let collaborationItem = try CollaborationItem(json: jsonDict)

                        expect(collaborationItem.debugDescription).to(equal("folder Optional(\"Test Folder\")"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
