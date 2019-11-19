//
//  RecentItems.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 8/27/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class RecentItemSpecs: QuickSpec {

    override func spec() {
        describe("Recent Item") {

            describe("init()") {

                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullRecentItem", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let recentItem = try RecentItem(json: jsonDict)

                        expect(recentItem.type).to(equal("recent_item"))
                        expect(recentItem.interactionType.description).to(equal("item_preview"))
                        expect(recentItem.interactedAt.iso8601).to(equal("2017-06-06T22:46:28Z"))

                        let file = recentItem.item
                        expect(file.type).to(equal("file"))
                        expect(file.id).to(equal("181937331928"))
                        expect(file.sequenceId).to(equal("0"))
                        expect(file.etag).to(equal("0"))
                        expect(file.sha1).to(equal("d0a8c75ba72bf923bfb0c855bbcf1e8f7cc817dd"))
                        expect(file.name).to(equal("File2.txt"))
                        guard let fileVersion = file.fileVersion, case let version: FileVersion = fileVersion else {
                            fail("Unable to unwrap expected file version")
                            return
                        }
                        expect(version.type).to(equal("file_version"))
                        expect(version.id).to(equal("192865288152"))
                        expect(version.sha1).to(equal("d0a8c75ba72bf923bfb0c855bbcf1e8f7cc817dd"))

                        expect(recentItem.interactionSharedLink).to(beNil())
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
