//
//  FolderSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Matthew Willer on 6/12/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class FolderSpecs: QuickSpec {

    override func spec() {
        describe("Folder") {

            describe("init()") {
                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullFolder", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let folder = try Folder(json: jsonDict)

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
                        expect(folder.createdBy?.type).to(equal("user"))
                        expect(folder.createdBy?.id).to(equal("22222"))
                        expect(folder.createdBy?.name).to(equal("Example User"))
                        expect(folder.createdBy?.login).to(equal("user@example.com"))
                        expect(folder.modifiedBy?.type).to(equal("user"))
                        expect(folder.modifiedBy?.id).to(equal("22222"))
                        expect(folder.modifiedBy?.name).to(equal("Example User"))
                        expect(folder.modifiedBy?.login).to(equal("user@example.com"))
                        expect(folder.ownedBy?.type).to(equal("user"))
                        expect(folder.ownedBy?.id).to(equal("22222"))
                        expect(folder.ownedBy?.name).to(equal("Example User"))
                        expect(folder.ownedBy?.login).to(equal("user@example.com"))
                        expect(folder.sharedLink?.url?.absoluteString).to(equal("https://app.box.com/s/ago2k14xz23vwcgnhk1u"))
                        expect(folder.sharedLink?.downloadURL).to(beNil())
                        expect(folder.sharedLink?.vanityURL).to(beNil())
                        expect(folder.sharedLink?.effectiveAccess).to(equal("open"))
                        expect(folder.sharedLink?.effectivePermission).to(equal("can_download"))
                        expect(folder.sharedLink?.isPasswordEnabled).to(beFalse())
                        expect(folder.sharedLink?.unsharedAt).to(beNil())
                        expect(folder.sharedLink?.downloadCount).to(equal(0))
                        expect(folder.sharedLink?.previewCount).to(equal(0))
                        expect(folder.sharedLink?.access).to(equal(.open))
                        expect(folder.sharedLink?.permissions?.canDownload).to(beTrue())
                        expect(folder.sharedLink?.permissions?.canPreview).to(beTrue())
                        expect(folder.folderUploadEmail?.access).to(equal("collaborators"))
                        expect(folder.folderUploadEmail?.email).to(equal("Test_Fo.sidu576dbfn@u.box.com"))
                        expect(folder.parent?.type).to(equal("folder"))
                        expect(folder.parent?.id).to(equal("0"))
                        expect(folder.parent?.sequenceId).to(beNil())
                        expect(folder.parent?.etag).to(beNil())
                        expect(folder.parent?.name).to(equal("All Files"))
                        expect(folder.itemStatus).to(equal(.active))
                        expect(folder.contentCreatedAt?.iso8601).to(equal("2013-06-01T22:52:00Z"))
                        expect(folder.contentModifiedAt?.iso8601).to(equal("2019-05-28T19:12:46Z"))
                        expect(folder.canNonOwnersInvite).to(beTrue())
                        expect(folder.trashedAt).to(beNil())
                        expect(folder.purgedAt).to(beNil())
                        expect(folder.syncState).to(equal(SyncState.notSynced))
                        expect(folder.hasCollaborations).to(beFalse())
                        expect(folder.permissions?.canDownload).to(beTrue())
                        expect(folder.permissions?.canUpload).to(beTrue())
                        expect(folder.permissions?.canRename).to(beTrue())
                        expect(folder.permissions?.canDelete).to(beTrue())
                        expect(folder.permissions?.canShare).to(beTrue())
                        expect(folder.permissions?.canInviteCollaborator).to(beTrue())
                        expect(folder.permissions?.canSetShareAccess).to(beTrue())
                        expect(folder.tags?.count).to(equal(1))
                        expect(folder.tags?[0]).to(equal("test"))
                        expect(folder.allowedSharedLinkAccessLevels?.count).to(equal(3))
                        expect(folder.allowedSharedLinkAccessLevels?[0]).to(equal(.collaborators))
                        expect(folder.allowedSharedLinkAccessLevels?[1]).to(equal(.open))
                        expect(folder.allowedSharedLinkAccessLevels?[2]).to(equal(.company))
                        expect(folder.allowedInviteeRoles?.count).to(equal(7))
                        expect(folder.allowedInviteeRoles?[0]).to(equal("viewer"))
                        expect(folder.allowedInviteeRoles?[1]).to(equal("editor"))
                        expect(folder.allowedInviteeRoles?[2]).to(equal("previewer"))
                        expect(folder.allowedInviteeRoles?[3]).to(equal("uploader"))
                        expect(folder.allowedInviteeRoles?[4]).to(equal("previewer uploader"))
                        expect(folder.allowedInviteeRoles?[5]).to(equal("co-owner"))
                        expect(folder.allowedInviteeRoles?[6]).to(equal("viewer uploader"))
                        expect(folder.isExternallyOwned).to(beFalse())
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
