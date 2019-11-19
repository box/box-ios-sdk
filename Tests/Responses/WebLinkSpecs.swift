//
//  WebLinkSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Matthew Willer on 6/17/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class WebLinkSpecs: QuickSpec {

    override func spec() {
        describe("WebLink") {
            describe("init()") {
                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullWebLink", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let webLink = try WebLink(json: jsonDict)

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
                        expect(webLink.parent?.type).to(equal("folder"))
                        expect(webLink.parent?.id).to(equal("33333"))
                        expect(webLink.parent?.sequenceId).to(equal("0"))
                        expect(webLink.parent?.etag).to(equal("0"))
                        expect(webLink.parent?.name).to(equal("Test Folder"))
                        expect(webLink.description).to(equal("A web link for testing"))
                        expect(webLink.itemStatus).to(equal(.active))
//                        expect(webLink.expiresAt).to(equal("2020-01-23T00:19:34Z"))
                        expect(webLink.permissions?.canRename).to(beTrue())
                        expect(webLink.permissions?.canDelete).to(beTrue())
                        expect(webLink.permissions?.canComment).to(beTrue())
                        expect(webLink.permissions?.canShare).to(beTrue())
                        expect(webLink.permissions?.canSetShareAccess).to(beTrue())
                        expect(webLink.trashedAt).to(beNil())
                        expect(webLink.purgedAt).to(beNil())
                        expect(webLink.sharedLink?.url?.absoluteString).to(equal("https://app.box.com/s/ioh1ue6n5htav8h3c0m3f1gj40pbxpnz"))
                        expect(webLink.sharedLink?.downloadURL).to(beNil())
                        expect(webLink.sharedLink?.vanityURL).to(beNil())
                        expect(webLink.sharedLink?.effectiveAccess).to(equal("company"))
                        expect(webLink.sharedLink?.effectivePermission).to(equal("can_download"))
                        expect(webLink.sharedLink?.isPasswordEnabled).to(beFalse())
                        expect(webLink.sharedLink?.unsharedAt).to(beNil())
                        expect(webLink.sharedLink?.downloadCount).to(equal(0))
                        expect(webLink.sharedLink?.previewCount).to(equal(0))
                        expect(webLink.sharedLink?.access).to(equal(.company))
                        expect(webLink.sharedLink?.permissions?.canDownload).to(beTrue())
                        expect(webLink.sharedLink?.permissions?.canPreview).to(beTrue())
                        expect(webLink.pathCollection?.totalCount).to(equal(2))
                        expect(webLink.pathCollection?.entries?.count).to(equal(2))
                        expect(webLink.pathCollection?.entries?[0].type).to(equal("folder"))
                        expect(webLink.pathCollection?.entries?[0].id).to(equal("0"))
                        expect(webLink.pathCollection?.entries?[0].sequenceId).to(beNil())
                        expect(webLink.pathCollection?.entries?[0].etag).to(beNil())
                        expect(webLink.pathCollection?.entries?[0].name).to(equal("All Files"))
                        expect(webLink.pathCollection?.entries?[1].type).to(equal("folder"))
                        expect(webLink.pathCollection?.entries?[1].id).to(equal("33333"))
                        expect(webLink.pathCollection?.entries?[1].sequenceId).to(equal("0"))
                        expect(webLink.pathCollection?.entries?[1].etag).to(equal("0"))
                        expect(webLink.pathCollection?.entries?[1].name).to(equal("Test Folder"))
                        expect(webLink.modifiedBy?.type).to(equal("user"))
                        expect(webLink.modifiedBy?.id).to(equal("22222"))
                        expect(webLink.modifiedBy?.name).to(equal("Example User"))
                        expect(webLink.modifiedBy?.login).to(equal("user@example.com"))
                        expect(webLink.ownedBy?.type).to(equal("user"))
                        expect(webLink.ownedBy?.id).to(equal("22222"))
                        expect(webLink.ownedBy?.name).to(equal("Example User"))
                        expect(webLink.ownedBy?.login).to(equal("user@example.com"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
