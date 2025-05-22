import Foundation
import BoxSdkGen
import XCTest

class TrashedFoldersManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testTrashedFolders() async throws {
        let folder: FolderFull = try await client.folders.createFolder(requestBody: CreateFolderRequestBody(name: Utils.getUUID(), parent: CreateFolderRequestBodyParentField(id: "0")))
        try await client.folders.deleteFolderById(folderId: folder.id)
        let fromTrash: TrashFolder = try await client.trashedFolders.getTrashedFolderById(folderId: folder.id)
        XCTAssertTrue(fromTrash.id == folder.id)
        XCTAssertTrue(fromTrash.name == folder.name)
        await XCTAssertThrowsErrorAsync(try await client.folders.getFolderById(folderId: folder.id))
        let restoredFolder: TrashFolderRestored = try await client.trashedFolders.restoreFolderFromTrash(folderId: folder.id)
        let fromApi: FolderFull = try await client.folders.getFolderById(folderId: folder.id)
        XCTAssertTrue(restoredFolder.id == fromApi.id)
        XCTAssertTrue(restoredFolder.name == fromApi.name)
        try await client.folders.deleteFolderById(folderId: folder.id)
        try await client.trashedFolders.deleteTrashedFolderById(folderId: folder.id)
        await XCTAssertThrowsErrorAsync(try await client.trashedFolders.getTrashedFolderById(folderId: folder.id))
    }
}
