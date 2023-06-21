//
//  SignRequestCreateRequestSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 14/10/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class SignRequestCreateRequestSpecs: QuickSpec {

    override class func spec() {

        describe("SignRequestCreateRequest") {

            describe("SignRequestCreateSourceFile") {

                describe("init()") {

                    it("should correctly create an object using init with id and fileVersionId parameters") {
                        let sut = SignRequestCreateSourceFile(id: "12345", fileVersionId: "123")
                        expect(sut.id).to(equal("12345"))
                        expect(sut.fileVersion?.id).to(equal("123"))
                    }

                    it("should correctly create an object using init with file object parameter") {
                        guard let filepath = TestAssets.path(forResource: "FullFile.json") else {
                            fail("Could not find fixture file.")
                            return
                        }

                        do {
                            let contents = try String(contentsOfFile: filepath)
                            let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                            let file = try File(json: jsonDict)

                            let sut = SignRequestCreateSourceFile(file: file)

                            expect(sut.id).to(equal("11111"))
                            expect(sut.fileVersion?.id).to(equal("44444"))
                        }
                        catch {
                            fail("Failed with Error: \(error)")
                        }
                    }
                }
            }

            describe("SignRequestCreateParentFolder") {

                describe("init()") {

                    it("should correctly create an object using init with id parameters") {
                        let sut = SignRequestCreateParentFolder(id: "12345")
                        expect(sut.id).to(equal("12345"))
                    }

                    it("should correctly create an object using init with folder object parameter") {
                        guard let filepath = TestAssets.path(forResource: "FullFolder.json") else {
                            fail("Could not find fixture file.")
                            return
                        }

                        do {
                            let contents = try String(contentsOfFile: filepath)
                            let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                            let folder = try Folder(json: jsonDict)

                            let sut = SignRequestCreateParentFolder(folder: folder)
                            expect(sut.id).to(equal("11111"))
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
