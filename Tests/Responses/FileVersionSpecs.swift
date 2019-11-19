//
//  FileVersionSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Matthew Willer on 6/12/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class FileVersionSpecs: QuickSpec {

    override func spec() {
        describe("FileVersion") {

            describe("init()") {
                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullFileVersion", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let fileVersion = try FileVersion(json: jsonDict)

                        expect(fileVersion.type).to(equal("file_version"))
                        expect(fileVersion.id).to(equal("11111"))
                        expect(fileVersion.sha1).to(equal("66b034c4281cc624495835a3b5cd80edbaaae688"))
                        expect(fileVersion.name).to(equal("Screen Shot 2015-08-24 at 11.34.42 AM (1).png"))
//                        expect(fileVersion.extension).to(equal("png"))
                        expect(fileVersion.size).to(equal(105_459))
                        expect(fileVersion.createdAt?.iso8601).to(equal("2018-05-29T18:40:53Z"))
                        expect(fileVersion.modifiedAt?.iso8601).to(equal("2018-05-29T18:40:53Z"))
                        expect(fileVersion.modifiedBy?.type).to(equal("user"))
                        expect(fileVersion.modifiedBy?.id).to(equal("22222"))
                        expect(fileVersion.modifiedBy?.name).to(equal("Example User"))
                        expect(fileVersion.modifiedBy?.login).to(equal("user@example.com"))
                        expect(fileVersion.restoredAt?.iso8601).to(equal("2018-05-29T18:40:53Z"))
                        expect(fileVersion.restoredBy?.type).to(equal("user"))
                        expect(fileVersion.restoredBy?.id).to(equal("22222"))
                        expect(fileVersion.restoredBy?.name).to(equal("Example User"))
                        expect(fileVersion.restoredBy?.login).to(equal("user@example.com"))
                        expect(fileVersion.trashedAt).to(beNil())
                        expect(fileVersion.trashedBy?.type).to(equal("user"))
                        expect(fileVersion.trashedBy?.id).to(equal("22222"))
                        expect(fileVersion.trashedBy?.name).to(equal("Example User"))
                        expect(fileVersion.trashedBy?.login).to(equal("user@example.com"))
                        expect(fileVersion.purgedAt).to(beNil())
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
