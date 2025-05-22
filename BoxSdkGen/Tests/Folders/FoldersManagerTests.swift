import Foundation
import BoxSdkGen
import XCTest

class FoldersManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testGetFolderInfo() async throws {
        let rootFolder: FolderFull = try await client.folders.getFolderById(folderId: "0")
        XCTAssertTrue(rootFolder.id == "0")
        XCTAssertTrue(rootFolder.name == "All Files")
        XCTAssertTrue(Utils.Strings.toString(value: rootFolder.type) == "folder")
    }

    public func testGetFolderFullInfoWithExtraFields() async throws {
        let rootFolder: FolderFull = try await client.folders.getFolderById(folderId: "0", queryParams: GetFolderByIdQueryParams(fields: ["has_collaborations", "tags"]))
        XCTAssertTrue(rootFolder.id == "0")
        XCTAssertTrue(rootFolder.hasCollaborations == false)
        let tagsLength: Int = rootFolder.tags!.count
        XCTAssertTrue(tagsLength == 0)
    }

    public func testCreateAndDeleteFolder() async throws {
        let newFolderName: String = Utils.getUUID()
        let newFolder: FolderFull = try await client.folders.createFolder(requestBody: CreateFolderRequestBody(name: newFolderName, parent: CreateFolderRequestBodyParentField(id: "0")))
        let createdFolder: FolderFull = try await client.folders.getFolderById(folderId: newFolder.id)
        XCTAssertTrue(createdFolder.name == newFolderName)
        try await client.folders.deleteFolderById(folderId: newFolder.id)
        await XCTAssertThrowsErrorAsync(try await client.folders.getFolderById(folderId: newFolder.id))
    }

    public func testUpdateFolder() async throws {
        let folderToUpdateName: String = Utils.getUUID()
        let folderToUpdate: FolderFull = try await client.folders.createFolder(requestBody: CreateFolderRequestBody(name: folderToUpdateName, parent: CreateFolderRequestBodyParentField(id: "0")))
        let updatedName: String = Utils.getUUID()
        let updatedFolder: FolderFull = try await client.folders.updateFolderById(folderId: folderToUpdate.id, requestBody: UpdateFolderByIdRequestBody(name: updatedName, description: "Updated description"))
        XCTAssertTrue(updatedFolder.name == updatedName)
        XCTAssertTrue(updatedFolder.description == "Updated description")
        try await client.folders.deleteFolderById(folderId: updatedFolder.id)
    }

    public func testCopyMoveFolderAndListFolderItems() async throws {
        let folderOriginName: String = Utils.getUUID()
        let folderOrigin: FolderFull = try await client.folders.createFolder(requestBody: CreateFolderRequestBody(name: folderOriginName, parent: CreateFolderRequestBodyParentField(id: "0")))
        let copiedFolderName: String = Utils.getUUID()
        let copiedFolder: FolderFull = try await client.folders.copyFolder(folderId: folderOrigin.id, requestBody: CopyFolderRequestBody(parent: CopyFolderRequestBodyParentField(id: "0"), name: copiedFolderName))
        XCTAssertTrue(copiedFolder.parent!.id == "0")
        let movedFolderName: String = Utils.getUUID()
        let movedFolder: FolderFull = try await client.folders.updateFolderById(folderId: copiedFolder.id, requestBody: UpdateFolderByIdRequestBody(name: movedFolderName, parent: UpdateFolderByIdRequestBodyParentField(id: folderOrigin.id)))
        XCTAssertTrue(movedFolder.parent!.id == folderOrigin.id)
        let folderItems: Items = try await client.folders.getFolderItems(folderId: folderOrigin.id)
        try await client.folders.deleteFolderById(folderId: movedFolder.id)
        try await client.folders.deleteFolderById(folderId: folderOrigin.id)
    }
}
