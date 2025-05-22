//
//  FolderModuleIntegrationSpecs.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 01/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class FolderModuleIntegrationSpecs: QuickSpec {

    override class func spec() {
        var client: BoxClient!
        var rootFolder: Folder!

        beforeSuite {
            initializeClient { createdClient in client = createdClient }
            createFolder(client: client, name: NameGenerator.getUniqueFolderName(for: "FolderModule")) { createdFolder in rootFolder = createdFolder }
        }

        afterSuite {
            deleteFolder(client: client, folder: rootFolder, recursive: true)
        }

        describe("Folders Module") {

            context("live cycle") {

                it("should correctly create get and delete a folder") {
                    var folder: Folder?
                    let folderName = NameGenerator.getUniqueFolderName()

                    // create
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.create(name: folderName, parentId: rootFolder.id) { result in
                            switch result {
                            case let .success(folderItem):
                                folder = folderItem
                            case let .failure(error):
                                fail("Expected create call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    guard let folder = folder else { return }

                    // get
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.get(folderId: folder.id) { result in
                            switch result {
                            case let .success(folderItem):
                                expect(folderItem).toNot(beNil())
                                expect(folderItem).to(beAKindOf(Folder.self))
                                expect(folderItem.name).to(equal(folderName))
                                expect(folderItem.parent?.id).to(equal(rootFolder.id))
                                expect(folderItem.itemStatus).to(equal(.active))
                            case let .failure(error):
                                fail("Expected get call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // delete
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.delete(folderId: folder.id) { result in
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

                beforeEach {
                    createFolder(client: client, name: NameGenerator.getUniqueFolderName(), parentId: rootFolder.id) { createdFolder in folder = createdFolder }

                    guard let folder = folder else { return }

                    createFolder(client: client, name: "folder_1", parentId: folder.id) { _ in }
                    createFolder(client: client, name: "folder_2", parentId: folder.id) { _ in }
                    createFolder(client: client, name: "folder_3", parentId: folder.id) { _ in }
                    createFolder(client: client, name: "folder_4", parentId: folder.id) { _ in }
                }

                afterEach {
                    deleteFolder(client: client, folder: folder, recursive: true)
                }

                it("should correctly list folder items when set offset") {
                    guard let folder = folder else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    let iterator = client.folders.listItems(folderId: folder.id, offset: 1, limit: 2)

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let folders = page.entries.compactMap { $0.folder }
                                expect(page.entries.count).to(equal(2))
                                expect(folders.count).to(equal(2))
                                expect(folders.map { $0.name }).to(contain(["folder_2", "folder_3"]))
                            case let .failure(error):
                                fail("Expected list call to succeed, but instead got \(error)")
                            }
                        }

                        done()
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let folders = page.entries.compactMap { $0.folder }
                                expect(page.entries.count).to(equal(1))
                                expect(folders.count).to(equal(1))
                                expect(folders.map { $0.name }).to(contain(["folder_4"]))
                            case let .failure(error):
                                fail("Expected list call to succeed, but instead got \(error)")
                            }
                        }

                        done()
                    }
                }

                it("should correctly list folder items when using marker") {
                    guard let folder = folder else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    let iterator = client.folders.listItems(folderId: folder.id, usemarker: true, limit: 1)

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let folders = page.entries.compactMap { $0.folder }
                                expect(page.entries.count).to(equal(1))
                                expect(folders.count).to(equal(1))
                                expect(folders.map { $0.name }).to(contain(["folder_1"]))
                            case let .failure(error):
                                fail("Expected list call to succeed, but instead got \(error)")
                            }
                        }

                        done()
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let folders = page.entries.compactMap { $0.folder }
                                expect(page.entries.count).to(equal(1))
                                expect(folders.count).to(equal(1))
                                expect(folders.map { $0.name }).to(contain(["folder_2"]))
                            case let .failure(error):
                                fail("Expected list call to succeed, but instead got \(error)")
                            }
                        }

                        done()
                    }
                }
            }

            context("update") {
                var folderName: String!
                var folder: Folder?
                var destinationFolder: Folder?

                beforeEach {
                    folderName = NameGenerator.getUniqueFolderName()
                    createFolder(client: client, name: folderName, parentId: rootFolder.id) { createdFolder in folder = createdFolder }
                    createFolder(client: client, name: NameGenerator.getUniqueFolderName(), parentId: rootFolder.id) { createdFolder in destinationFolder = createdFolder }
                }

                afterEach {
                    deleteFolder(client: client, folder: destinationFolder, recursive: true)
                }

                it("should correctly update folder") {
                    guard let folder = folder,
                          let destinationFolder = destinationFolder else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    let changedFolderName = NameGenerator.getUniqueFolderName()

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.update(
                            folderId: folder.id,
                            name: changedFolderName,
                            description: "sample description",
                            parentId: destinationFolder.id,
                            tags: ["sample tag 1"],
                            fields: ["name", "description", "tags", "parent"]
                        ) { result in
                            switch result {
                            case let .success(folderItem):
                                expect(folderItem.id).to(equal(folder.id))
                                expect(folderItem.parent?.id).to(equal(destinationFolder.id))
                                expect(folderItem.id).to(equal(folder.id))
                                expect(folderItem.name).to(equal(changedFolderName))
                                expect(folderItem.description).to(equal("sample description"))
                                expect(folderItem.tags?[0]).to(equal("sample tag 1"))
                            case let .failure(error):
                                fail("Expected update call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("copy") {
                var sourceFolder: Folder?

                var copiedFolderName: String!
                var copiedFolder: Folder?

                beforeEach {
                    createFolder(client: client, name: NameGenerator.getUniqueFolderName(), parentId: rootFolder.id) { createdFolder in sourceFolder = createdFolder }
                    copiedFolderName = NameGenerator.getUniqueFolderName()
                }

                afterEach {
                    deleteFolder(client: client, folder: sourceFolder)
                    deleteFolder(client: client, folder: copiedFolder)
                }

                it("should correctly copy folder") {
                    guard let sourceFolder = sourceFolder else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.copy(
                            folderId: sourceFolder.id,
                            destinationFolderID: rootFolder.id,
                            name: copiedFolderName
                        ) { result in
                            switch result {
                            case let .success(folderItem):
                                copiedFolder = folderItem
                                expect(folderItem.name).to(equal(copiedFolderName))
                                expect(folderItem.parent?.id).to(equal(rootFolder.id))
                                expect(folderItem.id).toNot(equal(sourceFolder.id))
                            case let .failure(error):
                                fail("Expected copy call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("collaborations") {
                var folderName: String!
                var folder: Folder?

                beforeEach {
                    folderName = NameGenerator.getUniqueFolderName()
                    createFolder(client: client, name: folderName, parentId: rootFolder.id) { createdFolder in folder = createdFolder }
                }

                afterEach {
                    deleteFolder(client: client, folder: folder)
                }

                it("should correctly add and list a collaborations for a folder") {
                    guard let folder = folder else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    var collaboration: Collaboration?

                    // create
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.collaborations.create(
                            itemType: "folder",
                            itemId: folder.id,
                            role: .editor,
                            accessibleBy: Configuration.shared.data.collaboratorId,
                            accessibleByType: .user,
                            fields: ["role", "accessible_by"]
                        ) { result in
                            switch result {
                            case let .success(collaborationItem):
                                collaboration = collaborationItem
                                expect(collaborationItem.role).to(equal(.editor))
                                expect(collaborationItem.accessibleByUser?.id).to(equal(Configuration.shared.data.collaboratorId))
                            case let .failure(error):
                                fail("Expected create call to suceeded, but it failed \(error)")
                            }

                            done()
                        }
                    }

                    guard let collaboration = collaboration else { return }

                    // listCollaborations
                    let iterator = client.folders.listCollaborations(folderId: folder.id, fields: ["role", "accessible_by"])
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.entries.count).to(equal(1))
                                expect(page.entries[0].id).to(equal(collaboration.id))
                                expect(page.entries[0].role).to(equal(.editor))
                                expect(page.entries[0].accessibleByUser?.id).to(equal(Configuration.shared.data.collaboratorId))
                            case let .failure(error):
                                fail("Expected listCollaborations call to succeeded, but it instead got: \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("favorites") {
                var folder: Folder?

                beforeEach {
                    createFolder(client: client, name: NameGenerator.getUniqueFolderName(), parentId: rootFolder.id) { createdFolder in folder = createdFolder }
                }

                afterEach {
                    deleteFolder(client: client, folder: folder)
                }

                it("should correctly add folder to and remove folder from favorites") {
                    guard let folder = folder else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    // addToFavorites
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.addToFavorites(folderId: folder.id) { result in
                            if case let .failure(error) = result {
                                fail("Expected addToFavorites call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // removeFromFavorites
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.removeFromFavorites(folderId: folder.id) { result in
                            if case let .failure(error) = result {
                                fail("Expected removeFromFavorites call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("shared link") {
                var folder: Folder?

                beforeEach {
                    createFolder(client: client, name: NameGenerator.getUniqueFolderName(), parentId: rootFolder.id) { createdFolder in folder = createdFolder }
                }

                afterEach {
                    deleteFolder(client: client, folder: folder)
                }

                it("should correctly set get delete a shared link") {
                    guard let folder = folder else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    // setSharedLink
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.setSharedLink(
                            forFolder: folder.id,
                            access: .open,
                            vanityName: .value("iOS-SDK-Folder-VanityName"),
                            password: .value("secretPassword"),
                            canDownload: true
                        ) { result in
                            switch result {
                            case let .success(sharedLink):
                                expect(sharedLink.access).to(equal(.open))
                                expect(sharedLink.permissions?.canDownload).to(equal(true))
                                expect(sharedLink.permissions?.canPreview).to(equal(true))
                                expect(sharedLink.permissions?.canEdit).to(equal(false))
                                expect(sharedLink.isPasswordEnabled).to(equal(true))
                                expect(sharedLink.vanityName).to(equal("iOS-SDK-Folder-VanityName"))
                            case let .failure(error):
                                fail("Expected setSharedLink call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // getSharedLink
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.getSharedLink(forFolder: folder.id) { result in
                            switch result {
                            case let .success(sharedLink):
                                expect(sharedLink.access).to(equal(.open))
                                expect(sharedLink.permissions?.canDownload).to(equal(true))
                                expect(sharedLink.permissions?.canPreview).to(equal(true))
                                expect(sharedLink.permissions?.canEdit).to(equal(false))
                                expect(sharedLink.isPasswordEnabled).to(equal(true))
                                expect(sharedLink.vanityName).to(equal("iOS-SDK-Folder-VanityName"))
                            case let .failure(error):
                                fail("Expected getSharedLink call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // deleteSharedLink
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.deleteSharedLink(forFolder: folder.id) { result in
                            if case let .failure(error) = result {
                                fail("Expected deleteSharedLink call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("watermark") {
                var folder: Folder?

                beforeEach {
                    createFolder(client: client, name: NameGenerator.getUniqueFolderName(), parentId: rootFolder.id) { createdFolder in folder = createdFolder }
                }

                afterEach {
                    deleteFolder(client: client, folder: folder)
                }

                it("should correctly apply get remove a watermark") {
                    guard let folder = folder else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    // applyWatermark
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.applyWatermark(folderId: folder.id) { result in
                            switch result {
                            case let .success(watermark):
                                expect(watermark).toNot(beNil())
                            case let .failure(error):
                                fail("Expected applyWatermark call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // getWatermark
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.getWatermark(folderId: folder.id) { result in
                            switch result {
                            case let .success(watermark):
                                expect(watermark).toNot(beNil())
                            case let .failure(error):
                                fail("Expected getWatermark call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // removeWatermark
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.removeWatermark(folderId: folder.id) { result in
                            if case let .failure(error) = result {
                                fail("Expected removeWatermark call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("lock") {
                var folder: Folder?

                beforeEach {
                    createFolder(client: client, name: NameGenerator.getUniqueFolderName(), parentId: rootFolder.id) { createdFolder in folder = createdFolder }
                }

                afterEach {
                    deleteFolder(client: client, folder: folder)
                }

                it("should correctly create get delete a lock") {
                    guard let folder = folder else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    var folderLock: FolderLock!

                    // createLock
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.createLock(folderId: folder.id) { result in
                            switch result {
                            case let .success(folderLockItem):
                                folderLock = folderLockItem
                                expect(folderLockItem).toNot(beNil())
                                expect(folderLockItem).to(beAKindOf(FolderLock.self))
                                expect(folderLockItem.lockType).to(equal("freeze"))
                            case let .failure(error):
                                fail("Expected createLock call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // listLocks
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        let iterator = client.folders.listLocks(folderId: folder.id)
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.entries.count).to(equal(1))
                                let item = page.entries[0]
                                expect(item).to(beAKindOf(FolderLock.self))
                                expect(item.id).to(equal(folderLock.id))
                            case let .failure(error):
                                fail("Expected listLocks call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // deleteLock
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.folders.deleteLock(folderLockId: folderLock.id) { result in
                            if case let .failure(error) = result {
                                fail("Expected deleteLock call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }
        }
    }
}
