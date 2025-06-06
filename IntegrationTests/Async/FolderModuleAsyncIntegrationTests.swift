//
//  FolderModuleAsyncIntegrationTests.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 24/05/2022.
//  Copyright © 2022 box. All rights reserved.
//

import BoxSDK
import XCTest

@available(iOS 13.0, *)
class FolderModuleAsyncIntegrationTests: BaseAsyncIntegrationTests {

    override func getRootFolderName() -> String {
        NameGenerator.getUniqueFolderName(for: "FolderModule")
    }

    func test_folder_live_cycle() async throws {
        let folderName = NameGenerator.getUniqueFolderName()

        // create
        let folder = try await client.folders.create(name: folderName, parentId: rootFolder.id)
        XCTAssertEqual(folder.name, folderName)

        // get
        let folderGet = try await client.folders.get(folderId: folder.id)
        XCTAssertEqual(folder.name, folderGet.name)
        XCTAssertEqual(folder.id, folderGet.id)
        XCTAssertEqual(folderGet.itemStatus, .active)

        // delete
        try await client.folders.delete(folderId: folder.id)
    }

    func test_folder_list() async throws {
        let folder = try await client.folders.create(
            name: NameGenerator.getUniqueFolderName(),
            parentId: rootFolder.id
        )

        _ = try await client.folders.create(name: "folder_1", parentId: folder.id)
        _ = try await client.folders.create(name: "folder_2", parentId: folder.id)
        _ = try await client.folders.create(name: "folder_3", parentId: folder.id)
        _ = try await client.folders.create(name: "folder_4", parentId: folder.id)

        let iterator = client.folders.listItems(folderId: folder.id, offset: 1, limit: 2)
        let firstPage = try await iterator.next()

        XCTAssertEqual(firstPage.entries.count, 2)
        XCTAssertEqual(firstPage.entries.compactMap { $0.folder?.name }, ["folder_2", "folder_3"])

        let secondPage = try await iterator.next()
        XCTAssertEqual(secondPage.entries.count, 1)
        XCTAssertEqual(secondPage.entries.compactMap { $0.folder?.name }, ["folder_4"])

        addTeardownBlock {
            try await self.client.folders.delete(folderId: folder.id, recursive: true)
        }
    }

    func test_folder_update() async throws {
        let sourceFolderName = NameGenerator.getUniqueFolderName()
        let sourceFolder = try await client.folders.create(
            name: sourceFolderName,
            parentId: rootFolder.id
        )

        let destinationFolderName = NameGenerator.getUniqueFolderName()
        let destinationFolder = try await client.folders.create(
            name: destinationFolderName,
            parentId: rootFolder.id
        )

        let changedFolderName = NameGenerator.getUniqueFolderName()

        let changedFolder = try await client.folders.update(
            folderId: sourceFolder.id,
            name: changedFolderName,
            description: "sample description",
            parentId: destinationFolder.id,
            tags: ["sample tag 1"],
            fields: ["name", "description", "tags", "parent"]
        )

        XCTAssertEqual(changedFolder.parent?.id, destinationFolder.id)
        XCTAssertEqual(changedFolder.id, sourceFolder.id)
        XCTAssertEqual(changedFolder.name, changedFolderName)
        XCTAssertEqual(changedFolder.description, "sample description")
        XCTAssertEqual(changedFolder.id, sourceFolder.id)
        XCTAssertEqual(changedFolder.tags?[0], "sample tag 1")

        addTeardownBlock {
            try await self.client.folders.delete(folderId: destinationFolder.id, recursive: true)
        }
    }

    func test_folder_copy() async throws {
        let sourceFolder = try await client.folders.create(
            name: NameGenerator.getUniqueFolderName(),
            parentId: rootFolder.id
        )

        let copiedFolderName = NameGenerator.getUniqueFolderName()

        let copiedFolder = try await client.folders.copy(
            folderId: sourceFolder.id,
            destinationFolderId: rootFolder.id,
            name: copiedFolderName
        )

        XCTAssertEqual(copiedFolder.name, copiedFolderName)
        XCTAssertEqual(copiedFolder.parent?.id, rootFolder.id)
        XCTAssertNotEqual(copiedFolder.id, sourceFolder.id)

        addTeardownBlock {
            try await self.client.folders.delete(folderId: sourceFolder.id)
            try await self.client.folders.delete(folderId: copiedFolder.id)
        }
    }

    func test_folder_favorites() async throws {
        let folder = try await client.folders.create(
            name: NameGenerator.getUniqueFolderName(),
            parentId: rootFolder.id
        )

        // add
        let folderWithCollection = try await client.folders.addToFavorites(folderId: folder.id, fields: ["collections"])
        let favoriteCollection = folderWithCollection.collections?.first(where: { item in item["name"] == "Favorites" })
        XCTAssertNotNil(favoriteCollection)

        // remove
        let folderWithoutCollection = try await client.folders.removeFromFavorites(folderId: folder.id, fields: ["collections"])
        let nilCollection = folderWithoutCollection.collections?.first(where: { item in item["name"] == "Favorites" })
        XCTAssertNil(nilCollection)

        addTeardownBlock {
            try await self.client.folders.delete(folderId: folder.id)
        }
    }

    func test_folder_shared_links() async throws {
        let folder = try await client.folders.create(
            name: NameGenerator.getUniqueFolderName(),
            parentId: rootFolder.id
        )

        // create
        let createdSharedLink = try await client.folders.setSharedLink(
            forFolder: folder.id,
            access: .open,
            vanityName: .value("iOS-SDK-Folder-VanityName"),
            password: .value("secretPassword"),
            canDownload: true
        )

        XCTAssertEqual(createdSharedLink.access, .open)
        XCTAssertEqual(createdSharedLink.permissions?.canDownload, true)
        XCTAssertEqual(createdSharedLink.permissions?.canPreview, true)
        XCTAssertEqual(createdSharedLink.permissions?.canEdit, false)
        XCTAssertEqual(createdSharedLink.isPasswordEnabled, true)
        XCTAssertEqual(createdSharedLink.vanityName, "iOS-SDK-Folder-VanityName")

        // get
        let fetchedSharedLink = try await client.folders.getSharedLink(forFolder: folder.id)

        XCTAssertEqual(fetchedSharedLink.access, .open)
        XCTAssertEqual(fetchedSharedLink.permissions?.canDownload, true)
        XCTAssertEqual(fetchedSharedLink.permissions?.canPreview, true)
        XCTAssertEqual(fetchedSharedLink.permissions?.canEdit, false)
        XCTAssertEqual(fetchedSharedLink.isPasswordEnabled, true)
        XCTAssertEqual(fetchedSharedLink.vanityName, "iOS-SDK-Folder-VanityName")

        // delete
        try await client.folders.deleteSharedLink(forFolder: folder.id)

        do {
            _ = try await client.folders.getSharedLink(forFolder: folder.id)
        }
        catch let error as BoxSDKError {
            XCTAssertEqual(error.message.description, "Not found: Folder shared link")
        }

        addTeardownBlock {
            try await self.client.folders.delete(folderId: folder.id)
        }
    }

    func test_folder_watermarks() async throws {
        let folder = try await client.folders.create(
            name: NameGenerator.getUniqueFolderName(),
            parentId: rootFolder.id
        )

        // create
        let createdWatermark = try await client.folders.applyWatermark(folderId: folder.id)
        XCTAssertNotNil(createdWatermark)

        // get
        let fetchedWatermark = try await client.folders.getWatermark(folderId: folder.id)
        XCTAssertNotNil(fetchedWatermark)
        XCTAssertEqual(fetchedWatermark.createdAt, createdWatermark.createdAt)
        XCTAssertEqual(fetchedWatermark.modifiedAt, createdWatermark.modifiedAt)

        // delete
        try await client.folders.removeWatermark(folderId: folder.id)

        do {
            _ = try await client.folders.getWatermark(folderId: folder.id)
        }
        catch {
            XCTAssertTrue(error is BoxSDKError)
        }

        addTeardownBlock {
            try await self.client.folders.delete(folderId: folder.id)
        }
    }

    func test_folder_locks() async throws {
        let folder = try await client.folders.create(
            name: NameGenerator.getUniqueFolderName(),
            parentId: rootFolder.id
        )

        // create
        let createdLock = try await client.folders.createLock(folderId: folder.id)
        XCTAssertEqual(createdLock.lockType, "freeze")

        // list
        let iterator = client.folders.listLocks(folderId: folder.id)
        let page = try await iterator.next()
        XCTAssertEqual(page.entries.count, 1)
        XCTAssertEqual(page.entries[0].id, createdLock.id)

        // delete
        try await client.folders.deleteLock(folderLockId: createdLock.id)
        let iteratorAfterDelete = client.folders.listLocks(folderId: folder.id)
        let pageAfterDelete = try await iteratorAfterDelete.next()
        XCTAssertEqual(pageAfterDelete.entries.count, 0)

        addTeardownBlock {
            try await self.client.folders.delete(folderId: folder.id)
        }
    }
}
