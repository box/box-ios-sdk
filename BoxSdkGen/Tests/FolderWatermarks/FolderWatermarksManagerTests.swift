import Foundation
import BoxSdkGen
import XCTest

class FolderWatermarksManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testCreateGetDeleteFolderWatermark() async throws {
        let folderName: String = Utils.getUUID()
        let folder: FolderFull = try await client.folders.createFolder(requestBody: CreateFolderRequestBody(name: folderName, parent: CreateFolderRequestBodyParentField(id: "0")))
        let createdWatermark: Watermark = try await client.folderWatermarks.updateFolderWatermark(folderId: folder.id, requestBody: UpdateFolderWatermarkRequestBody(watermark: UpdateFolderWatermarkRequestBodyWatermarkField(imprint: UpdateFolderWatermarkRequestBodyWatermarkImprintField.default_)))
        let watermark: Watermark = try await client.folderWatermarks.getFolderWatermark(folderId: folder.id)
        try await client.folderWatermarks.deleteFolderWatermark(folderId: folder.id)
        await XCTAssertThrowsErrorAsync(try await client.folderWatermarks.getFolderWatermark(folderId: folder.id))
        try await client.folders.deleteFolderById(folderId: folder.id)
    }
}
