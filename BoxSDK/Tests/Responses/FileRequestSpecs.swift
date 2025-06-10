//
//  FileRequestSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 09/08/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class FileRequestSpecs: QuickSpec {

    override class func spec() {
        describe("FileRequest") {

            describe("init()") {

                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = TestAssets.path(forResource: "GetFileRequest.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let fileRequest = try FileRequest(json: jsonDict)

                        expect(fileRequest.type).to(equal("file_request"))
                        expect(fileRequest.id).to(equal("42037322"))
                        expect(fileRequest.title).to(equal("Please upload documents"))
                        expect(fileRequest.description).to(equal("Following documents are requested for your process"))
                        expect(fileRequest.status).to(equal(.active))
                        expect(fileRequest.isEmailRequired).to(equal(true))
                        expect(fileRequest.isDescriptionRequired).to(equal(true))
                        expect(fileRequest.expiresAt?.iso8601).to(equal("2020-09-28T18:53:43Z"))
                        expect(fileRequest.url).to(equal("/f/19e57f40ace247278a8e3d336678c64a"))
                        expect(fileRequest.etag).to(equal("1"))
                        expect(fileRequest.createdAt.iso8601).to(equal("2020-09-28T18:53:43Z"))
                        expect(fileRequest.createdBy?.type).to(equal("user"))
                        expect(fileRequest.createdBy?.id).to(equal("11446498"))
                        expect(fileRequest.createdBy?.name).to(equal("Aaron Levie"))
                        expect(fileRequest.createdBy?.login).to(equal("ceo@example.com"))
                        expect(fileRequest.updatedAt.iso8601).to(equal("2020-09-28T18:53:43Z"))
                        expect(fileRequest.updatedBy?.type).to(equal("user"))
                        expect(fileRequest.updatedBy?.id).to(equal("11446498"))
                        expect(fileRequest.updatedBy?.name).to(equal("Aaron Levie"))
                        expect(fileRequest.updatedBy?.login).to(equal("ceo@example.com"))
                        expect(fileRequest.folder.id).to(equal("12345"))
                        expect(fileRequest.folder.etag).to(equal("1"))
                        expect(fileRequest.folder.type).to(equal("folder"))
                        expect(fileRequest.folder.sequenceId).to(equal("3"))
                        expect(fileRequest.folder.name).to(equal("Contracts"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }

        describe("FileRequestStatus") {

            describe("init()") {

                it("should correctly create an enum value from it's string representation") {
                    expect(FileRequestStatus.active).to(equal(FileRequestStatus(FileRequestStatus.active.description)))
                    expect(FileRequestStatus.inactive).to(equal(FileRequestStatus(FileRequestStatus.inactive.description)))
                    expect(FileRequestStatus.customValue("custom value")).to(equal(FileRequestStatus("custom value")))
                }
            }
        }
    }
}
