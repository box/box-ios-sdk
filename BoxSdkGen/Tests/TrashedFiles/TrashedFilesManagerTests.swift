import Foundation
import BoxSdkGen
import XCTest

class TrashedFilesManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testTrashedFiles() async throws {
        let fileSize: Int = 1024 * 1024
        let fileName: String = Utils.getUUID()
        let fileByteStream: InputStream = Utils.generateByteStream(size: fileSize)
        let files: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: fileName, parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: fileByteStream))
        let file: FileFull = files.entries![0]
        try await client.files.deleteFileById(fileId: file.id)
        let fromTrash: TrashFile = try await client.trashedFiles.getTrashedFileById(fileId: file.id)
        XCTAssertTrue(fromTrash.id == file.id)
        XCTAssertTrue(fromTrash.name == file.name)
        let fromApiAfterTrashed: FileFull = try await client.files.getFileById(fileId: file.id)
        XCTAssertTrue(Utils.Strings.toString(value: fromApiAfterTrashed.itemStatus) == "trashed")
        let restoredFile: TrashFileRestored = try await client.trashedFiles.restoreFileFromTrash(fileId: file.id)
        let fromApiAfterRestore: FileFull = try await client.files.getFileById(fileId: file.id)
        XCTAssertTrue(restoredFile.id == fromApiAfterRestore.id)
        XCTAssertTrue(restoredFile.name == fromApiAfterRestore.name)
        XCTAssertTrue(Utils.Strings.toString(value: fromApiAfterRestore.itemStatus) == "active")
        try await client.files.deleteFileById(fileId: file.id)
        try await client.trashedFiles.deleteTrashedFileById(fileId: file.id)
        await XCTAssertThrowsErrorAsync(try await client.trashedFiles.getTrashedFileById(fileId: file.id))
    }
}
