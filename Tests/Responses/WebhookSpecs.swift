//
//  WebhookSpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 8/30/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class WebhookSpecs: QuickSpec {

    override class func spec() {
        describe("Webhook") {

            describe("init()") {

                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = TestAssets.path(forResource: "FullWebhook.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let webhook = try Webhook(json: jsonDict)

                        expect(webhook.type).to(equal("webhook"))
                        guard case let .file(file)? = webhook.target else {
                            fail("Failed: Expected file object as target")
                            return
                        }
                        expect(file.id).to(equal("5018848529"))
                        expect(file.type).to(equal("file"))
                        expect(webhook.createdBy?.type).to(equal("user"))
                        expect(webhook.createdBy?.id).to(equal("2030392653"))
                        expect(webhook.createdBy?.name).to(equal("John Q. Developer"))
                        expect(webhook.createdBy?.login).to(equal("johnq@example.net"))
                        expect(webhook.createdAt?.iso8601).to(equal("2016-05-05T01:51:45Z"))
                        expect(webhook.address).to(equal(URL(string: "https://example.net/actions/file_changed")))
                        expect(webhook.triggers?[0].description).to(equal("FILE.PREVIEWED"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }

            describe("EventTriggers") {

                describe("init()") {

                    it("should correctly create an enum value from it's string representation") {
                        expect(Webhook.EventTriggers.fileUploaded).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.fileUploaded.description)))
                        expect(Webhook.EventTriggers.filePreviewed).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.filePreviewed.description)))
                        expect(Webhook.EventTriggers.fileDownloaded).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.fileDownloaded.description)))
                        expect(Webhook.EventTriggers.fileTrashed).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.fileTrashed.description)))
                        expect(Webhook.EventTriggers.fileDeleted).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.fileDeleted.description)))
                        expect(Webhook.EventTriggers.fileRestored).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.fileRestored.description)))
                        expect(Webhook.EventTriggers.fileCopied).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.fileCopied.description)))
                        expect(Webhook.EventTriggers.fileMoved).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.fileMoved.description)))
                        expect(Webhook.EventTriggers.fileLocked).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.fileLocked.description)))
                        expect(Webhook.EventTriggers.fileUnlocked).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.fileUnlocked.description)))
                        expect(Webhook.EventTriggers.fileRenamed).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.fileRenamed.description)))
                        expect(Webhook.EventTriggers.commentCreated).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.commentCreated.description)))
                        expect(Webhook.EventTriggers.commentUpdated).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.commentUpdated.description)))
                        expect(Webhook.EventTriggers.commentDeleted).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.commentDeleted.description)))
                        expect(Webhook.EventTriggers.taskAssignmentCreated).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.taskAssignmentCreated.description)))
                        expect(Webhook.EventTriggers.taskAssignmentUpdated).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.taskAssignmentUpdated.description)))
                        expect(Webhook.EventTriggers.metadataInstanceCreated).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.metadataInstanceCreated.description)))
                        expect(Webhook.EventTriggers.metadataInstanceUpdated).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.metadataInstanceUpdated.description)))
                        expect(Webhook.EventTriggers.metadataInstanceDeleted).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.metadataInstanceDeleted.description)))
                        expect(Webhook.EventTriggers.folderCreated).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.folderCreated.description)))
                        expect(Webhook.EventTriggers.folderCopied).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.folderCopied.description)))
                        expect(Webhook.EventTriggers.folderRenamed).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.folderRenamed.description)))
                        expect(Webhook.EventTriggers.folderDownloaded).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.folderDownloaded.description)))
                        expect(Webhook.EventTriggers.folderRestored).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.folderRestored.description)))
                        expect(Webhook.EventTriggers.folderDeleted).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.folderDeleted.description)))
                        expect(Webhook.EventTriggers.folderMoved).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.folderMoved.description)))
                        expect(Webhook.EventTriggers.folderTrashed).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.folderTrashed.description)))
                        expect(Webhook.EventTriggers.webhookDeleted).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.webhookDeleted.description)))
                        expect(Webhook.EventTriggers.collaborationCreated).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.collaborationCreated.description)))
                        expect(Webhook.EventTriggers.collaborationAccepted).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.collaborationAccepted.description)))
                        expect(Webhook.EventTriggers.collaborationRejected).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.collaborationRejected.description)))
                        expect(Webhook.EventTriggers.collaborationRemoved).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.collaborationRemoved.description)))
                        expect(Webhook.EventTriggers.collaborationUpdated).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.collaborationUpdated.description)))
                        expect(Webhook.EventTriggers.sharedLinkDeleted).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.sharedLinkDeleted.description)))
                        expect(Webhook.EventTriggers.sharedLinkCreated).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.sharedLinkCreated.description)))
                        expect(Webhook.EventTriggers.sharedLinkUpdated).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.sharedLinkUpdated.description)))
                        expect(Webhook.EventTriggers.signRequestCompleted).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.signRequestCompleted.description)))
                        expect(Webhook.EventTriggers.signRequestDeclined).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.signRequestDeclined.description)))
                        expect(Webhook.EventTriggers.signRequestExpired).to(equal(Webhook.EventTriggers(Webhook.EventTriggers.signRequestExpired.description)))
                        expect(Webhook.EventTriggers.customValue("custom value")).to(equal(Webhook.EventTriggers("custom value")))
                    }
                }
            }
        }
    }
}
