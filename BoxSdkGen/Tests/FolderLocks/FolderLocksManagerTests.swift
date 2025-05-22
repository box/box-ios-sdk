import Foundation
import BoxSdkGen
import XCTest

class FolderLocksManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testFolderLocks() async throws {
        let folder: FolderFull = try await CommonsManager().createNewFolder()
        let folderLocks: FolderLocks = try await client.folderLocks.getFolderLocks(queryParams: GetFolderLocksQueryParams(folderId: folder.id))
        XCTAssertTrue(folderLocks.entries!.count == 0)
        let folderLock: FolderLock = try await client.folderLocks.createFolderLock(requestBody: CreateFolderLockRequestBody(folder: CreateFolderLockRequestBodyFolderField(type: "folder", id: folder.id), lockedOperations: CreateFolderLockRequestBodyLockedOperationsField(move: true, delete: true)))
        XCTAssertTrue(folderLock.folder!.id == folder.id)
        XCTAssertTrue(folderLock.lockedOperations!.move == true)
        XCTAssertTrue(folderLock.lockedOperations!.delete == true)
        try await client.folderLocks.deleteFolderLockById(folderLockId: folderLock.id!)
        await XCTAssertThrowsErrorAsync(try await client.folderLocks.deleteFolderLockById(folderLockId: folderLock.id!))
        let newFolderLocks: FolderLocks = try await client.folderLocks.getFolderLocks(queryParams: GetFolderLocksQueryParams(folderId: folder.id))
        XCTAssertTrue(newFolderLocks.entries!.count == 0)
        try await client.folders.deleteFolderById(folderId: folder.id)
    }
}
