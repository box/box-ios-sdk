//
//  FileSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Matthew Willer on 6/11/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class FileSpecs: QuickSpec {

    override func spec() {
        describe("File") {

            describe("init()") {

                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullFile", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let file = try File(json: jsonDict)

                        expect(file.type).to(equal("file"))
                        expect(file.id).to(equal("11111"))
                        expect(file.etag).to(equal("2"))
                        expect(file.sequenceId).to(equal("2"))
                        expect(file.sha1).to(equal("14acc506f2021b2f1a9d81097ca82e14887b34fe"))
                        expect(file.name).to(equal("script.js"))
                        expect(file.extension).to(equal("js"))
                        expect(file.description).to(equal("My test script"))
                        expect(file.size).to(equal(33510))

                        guard let pathCollection = file.pathCollection else {
                            fail("Expected path collection to be present")
                            return
                        }
                        expect(pathCollection.totalCount).to(equal(2))
                        expect(pathCollection.entries?.count).to(equal(2))
                        expect(pathCollection.entries?[0]).toNot(beNil())
                        expect(pathCollection.entries?[0].type).to(equal("folder"))
                        expect(pathCollection.entries?[0].id).to(equal("0"))
                        expect(pathCollection.entries?[0].sequenceId).to(beNil())
                        expect(pathCollection.entries?[0].etag).to(beNil())
                        expect(pathCollection.entries?[0].name).to(equal("All Files"))
                        expect(pathCollection.entries?[1]).toNot(beNil())
                        expect(pathCollection.entries?[1].type).to(equal("folder"))
                        expect(pathCollection.entries?[1].id).to(equal("22222"))
                        expect(pathCollection.entries?[1].sequenceId).to(equal("0"))
                        expect(pathCollection.entries?[1].etag).to(equal("0"))
                        expect(pathCollection.entries?[1].name).to(equal("Test Folder"))

                        expect(file.commentCount).to(equal(0))
                        expect(file.createdAt?.iso8601).to(equal("2018-02-27T18:57:08Z"))
                        expect(file.modifiedAt?.iso8601).to(equal("2018-02-27T18:57:14Z"))
                        expect(file.trashedAt).to(beNil())
                        expect(file.purgedAt).to(beNil())
                        expect(file.contentCreatedAt?.iso8601).to(equal("2017-10-09T22:09:01Z"))
                        expect(file.contentModifiedAt?.iso8601).to(equal("2017-10-09T22:09:01Z"))
                        expect(file.isPackage).to(beFalse())
                        expect(file.createdBy?.type).to(equal("user"))
                        expect(file.createdBy?.id).to(equal("33333"))
                        expect(file.createdBy?.name).to(equal("Example User"))
                        expect(file.createdBy?.login).to(equal("user@example.com"))
                        expect(file.modifiedBy?.type).to(equal("user"))
                        expect(file.modifiedBy?.id).to(equal("33333"))
                        expect(file.modifiedBy?.name).to(equal("Example User"))
                        expect(file.modifiedBy?.login).to(equal("user@example.com"))
                        expect(file.ownedBy?.type).to(equal("user"))
                        expect(file.ownedBy?.id).to(equal("33333"))
                        expect(file.ownedBy?.name).to(equal("Example User"))
                        expect(file.ownedBy?.login).to(equal("user@example.com"))
                        expect(file.sharedLink?.url).to(equal(URL(string: "https://app.box.com/s/vc35nxi6vid83lf8lh5xabtrwmiqiy7a")!))
                        expect(file.sharedLink?.downloadURL).to(equal(URL(string: "https://app.box.com/shared/static/vc35nxi6vid83lf8lh5xabtrwmiqiy7a.js")!))
                        expect(file.sharedLink?.vanityURL).to(beNil())
                        expect(file.sharedLink?.effectiveAccess).to(equal("company"))
                        expect(file.sharedLink?.effectivePermission).to(equal("can_download"))
                        expect(file.sharedLink?.isPasswordEnabled).to(beFalse())
                        expect(file.sharedLink?.unsharedAt).to(beNil())
                        expect(file.sharedLink?.downloadCount).to(equal(0))
                        expect(file.sharedLink?.previewCount).to(equal(0))
                        expect(file.sharedLink?.access).to(equal(.company))
                        expect(file.sharedLink?.permissions?.canDownload).to(beTrue())
                        expect(file.sharedLink?.permissions?.canPreview).to(beTrue())
                        expect(file.parent?.type).to(equal("folder"))
                        expect(file.parent?.id).to(equal("22222"))
                        expect(file.parent?.sequenceId).to(equal("0"))
                        expect(file.parent?.etag).to(equal("0"))
                        expect(file.parent?.name).to(equal("Test Folder"))
                        expect(file.itemStatus).to(equal(ItemStatus.active))
                        expect(file.fileVersion?.type).to(equal("file_version"))
                        expect(file.fileVersion?.id).to(equal("44444"))
                        expect(file.fileVersion?.sha1).to(equal("14acc506f2021b2f1a9d81097ca82e14887b34fe"))
                        expect(file.versionNumber).to(equal("1"))
                        expect(file.expiresAt).to(beNil())
                        expect(file.permissions?.canDownload).to(beTrue())
                        expect(file.permissions?.canPreview).to(beTrue())
                        expect(file.permissions?.canUpload).to(beTrue())
                        expect(file.permissions?.canComment).to(beTrue())
                        expect(file.permissions?.canRename).to(beTrue())
                        expect(file.permissions?.canDelete).to(beTrue())
                        expect(file.permissions?.canShare).to(beTrue())
                        expect(file.permissions?.canSetShareAccess).to(beTrue())
                        expect(file.permissions?.canInviteCollaborator).to(beTrue())
                        expect(file.permissions?.canAnnotate).to(beFalse())
                        expect(file.permissions?.canViewAnnotationsAll).to(beTrue())
                        expect(file.permissions?.canViewAnnotationsAll).to(beTrue())
                        expect(file.lock?.type).to(equal("lock"))
                        expect(file.lock?.id).to(equal("55555"))
                        expect(file.lock?.createdBy?.type).to(equal("user"))
                        expect(file.lock?.createdBy?.id).to(equal("33333"))
                        expect(file.lock?.createdBy?.name).to(equal("Example User"))
                        expect(file.lock?.createdBy?.login).to(equal("user@example.com"))
                        expect(file.lock?.createdAt?.iso8601).to(equal("2019-06-11T21:45:08Z"))
                        expect(file.lock?.expiresAt?.iso8601).to(equal("2019-06-12T21:45:08Z"))
                        expect(file.lock?.isDownloadPrevented).to(beTrue())
//                        expect(file.isHideCollaboratorsEnabled).to(beFalse())
                        expect(file.tags?.count).to(equal(1))
                        expect(file.tags?[0]).to(equal("script"))
                        expect(file.hasCollaborations).to(beFalse())
                        expect(file.isExternallyOwned).to(beFalse())
                        expect(file.allowedInviteeRoles?.count).to(equal(2))
                        expect(file.allowedInviteeRoles?[0]).to(equal(.editor))
                        expect(file.allowedInviteeRoles?[1]).to(equal(.viewer))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
