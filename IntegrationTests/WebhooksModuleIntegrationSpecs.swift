//
//  WebhooksModuleIntegrationSpecs.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 13/10/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class WebhooksModuleIntegrationSpecs: BaseIntegrationSpecs {
    var rootFolder: Folder!

    override func spec() {

        beforeSuite {
            self.initializeClient()
            self.createFolder(name: NameGenerator.getUniqueFolderName(for: "WebhooksModule")) { [weak self] createdFolder in self?.rootFolder = createdFolder }
        }

        afterSuite {
            self.deleteFolder(self.rootFolder, recursive: true)
        }

        describe("Webhooks Module") {

            context("live cycle") {
                var file: File?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallImage.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly create update get and delete a webhook") {
                    guard let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    var webhook: Webhook?

                    // create
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.webhooks.create(
                            targetType: "file",
                            targetId: file.id,
                            triggers: [.fileDownloaded, .commentCreated, .sharedLinkCreated],
                            address: "https://example.com/webhooks"
                        ) { result in
                            switch result {
                            case let .success(webhookItem):
                                webhook = webhookItem
                                expect(webhookItem.address).to(equal(URL(string: "https://example.com/webhooks")))
                                expect(webhookItem.triggers).to(contain([.fileDownloaded, .commentCreated, .sharedLinkCreated]))
                                expect(webhookItem.target?.rawData["id"] as? String).to(equal(file.id))

                                guard case let .file(targetFile) = webhookItem.target else {
                                    fail("Expected file object as target")
                                    return
                                }
                                expect(targetFile.id).to(equal(file.id))
                            case let .failure(error):
                                fail("Expected create call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    guard let webhook = webhook else { return }

                    // update
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.webhooks.update(
                            webhookId: webhook.id,
                            triggers: [.taskAssignmentUpdated, .metadataInstanceDeleted, .fileCopied],
                            address: "https://example.com/webhooks2"

                        ) { result in
                            switch result {
                            case let .success(webhookItem):
                                expect(webhookItem.address).to(equal(URL(string: "https://example.com/webhooks2")))
                                expect(webhookItem.triggers).to(contain([.taskAssignmentUpdated, .metadataInstanceDeleted, .fileCopied]))
                                expect(webhookItem.target?.rawData["id"] as? String).to(equal(file.id))
                            case let .failure(error):
                                fail("Expected update call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // get
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.webhooks.get(webhookId: webhook.id) { result in
                            switch result {
                            case let .success(webhookItem):
                                expect(webhookItem.address).to(equal(URL(string: "https://example.com/webhooks2")))
                                expect(webhookItem.triggers).to(contain([.taskAssignmentUpdated, .metadataInstanceDeleted, .fileCopied]))
                                expect(webhookItem.target?.rawData["id"] as? String).to(equal(file.id))

                                guard case let .file(targetFile) = webhookItem.target else {
                                    fail("Expected file object as target")
                                    return
                                }
                                expect(targetFile.id).to(equal(file.id))
                            case let .failure(error):
                                fail("Expected get call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // delete
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.webhooks.delete(webhookId: webhook.id) { result in
                            if case let .failure(error) = result {
                                fail("Expected delete call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("list") {
                var folder: Folder?
                var file: File?

                beforeEach {
                    self.createFolder(name: self.rootFolder.id) { createdFolder in folder = createdFolder }
                    guard let folder = folder else { return }

                    self.uploadFile(fileName: IntegrationTestResources.smallImage.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                    guard let file = file else { return }

                    self.createWebhook(
                        targetType: "folder",
                        targetId: folder.id,
                        triggers: [.folderDownloaded, .signRequestExpired],
                        address: "https://example.com/webhooks"
                    ) { _ in }

                    self.createWebhook(
                        targetType: "file",
                        targetId: file.id,
                        triggers: [.fileRenamed],
                        address: "https://example.com/webhooks"
                    ) { _ in }
                }

                afterEach {
                    self.deleteFile(file)
                    self.deleteFolder(folder)
                }

                it("should correctly list all webhook items") {
                    guard let folder = folder, let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    let iterator = self.client.webhooks.list()

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.entries.count).to(equal(2))
                                expect(page.entries.map { $0.target?.rawData["id"] as! String }).to(contain([folder.id, file.id]))
                            case let .failure(error):
                                fail("Expected list call to succeed, but instead got \(error)")
                            }
                        }

                        done()
                    }
                }
            }

            context("EventTriggers") {
                var file: File?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallImage.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly create webhook with SIGN_REQUEST triggers") {
                    guard let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.webhooks.create(
                            targetType: "file",
                            targetId: file.id,
                            triggers: [.signRequestExpired, .signRequestDeclined, .signRequestCompleted],
                            address: "https://example.com/webhooks"
                        ) { result in
                            switch result {
                            case let .success(webhookItem):
                                expect(webhookItem.address).to(equal(URL(string: "https://example.com/webhooks")))
                                expect(webhookItem.triggers).to(contain([.signRequestExpired, .signRequestDeclined, .signRequestCompleted]))
                                expect(webhookItem.target?.rawData["id"] as? String).to(equal(file.id))

                                guard case let .file(targetFile) = webhookItem.target else {
                                    fail("Expected file object as target")
                                    return
                                }
                                expect(targetFile.id).to(equal(file.id))
                            case let .failure(error):
                                fail("Expected create call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }
        }
    }
}
