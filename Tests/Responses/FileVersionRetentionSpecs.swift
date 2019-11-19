//
//  FileVersionRetentionSpecs.swift
//  BoxSDK
//
//  Created by Sujay Garlanka on 9/27/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class FileVersionRetentionSpecs: QuickSpec {

    override func spec() {
        describe("File Version Retention") {

            describe("init()") {

                it("should correctly deserialize file version retention from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullFileVersionRetention", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let fileVersionRetention = try FileVersionRetention(json: jsonDict)

                        expect(fileVersionRetention.type).to(equal("file_version_retention"))
                        expect(fileVersionRetention.id).to(equal("12345"))
                        expect(fileVersionRetention.appliedAt?.iso8601).to(equal("2015-08-06T19:02:24Z"))
                        expect(fileVersionRetention.dispositionAt?.iso8601).to(equal("2016-08-06T18:45:28Z"))
                        expect(fileVersionRetention.winningRetentionPolicy?.type).to(equal("retention_policy"))
                        expect(fileVersionRetention.winningRetentionPolicy?.id).to(equal("123"))
                        expect(fileVersionRetention.winningRetentionPolicy?.name).to(equal("Tax Documents"))
                        expect(fileVersionRetention.fileVersion?.type).to(equal("file_version"))
                        expect(fileVersionRetention.fileVersion?.id).to(equal("123456"))
                        expect(fileVersionRetention.fileVersion?.sha1).to(equal("4262d326250e6f440dca43a2337bd4621bad9136"))
                        expect(fileVersionRetention.file?.type).to(equal("file"))
                        expect(fileVersionRetention.file?.id).to(equal("98765"))
                        expect(fileVersionRetention.file?.etag).to(equal("2"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
