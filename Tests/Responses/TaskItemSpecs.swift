//
//  TaskItemSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 21/09/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class TaskItemSpecs: QuickSpec {

    override class func spec() {
        describe("Task Item") {

            describe("init()") {

                it("should correctly deserialize a file type from full JSON representation") {
                    guard let filepath = TestAssets.path(forResource: "FullFile.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let taskItem = try TaskItem(json: jsonDict)

                        guard case let .file(file) = taskItem else {
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

                it("should throw BoxCodingError.valueMismatch exception when deserialize an object with an unknown value in type field") {
                    guard let filepath = TestAssets.path(forResource: "FullFile_ValueFormatMismatch.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let taskItemDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                        let expectedError = BoxCodingError(message: .valueMismatch(key: "type", value: "invalid_type_value", acceptedValues: ["file"]))
                        expect(try TaskItem(json: taskItemDictionary as! [String: Any])).to(throwError(expectedError))
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
                        let taskItemDictionary = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!)
                        let expectedError = BoxCodingError(message: .typeMismatch(key: "type"))
                        expect(try TaskItem(json: taskItemDictionary as! [String: Any])).to(throwError(expectedError))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }

            describe("rawData") {
                it("should be equal to json data used to create the TaskItem file type object") {
                    guard let filepath = TestAssets.path(forResource: "FullFile.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let taskItem = try TaskItem(json: jsonDict)

                        expect(JSONComparer.match(json1: taskItem.rawData, json2: jsonDict)).to(equal(true))
                        expect(taskItem.json()).to(equal(taskItem.toJSONString()))
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
                        let taskItem = try TaskItem(json: jsonDict)
                        expect(taskItem.debugDescription).to(equal("file Optional(\"script.js\")"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
