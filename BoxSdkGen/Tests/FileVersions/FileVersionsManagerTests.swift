import Foundation
import BoxSdkGen
import XCTest

class FileVersionsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testCreateListGetPromoteFileVersion() async throws {
        let oldName: String = Utils.getUUID()
        let newName: String = Utils.getUUID()
        let files: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: oldName, parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: Utils.generateByteStream(size: 10)))
        let file: FileFull = files.entries![0]
        XCTAssertTrue(file.name == oldName)
        XCTAssertTrue(file.size == 10)
        let newFiles: Files = try await client.uploads.uploadFileVersion(fileId: file.id, requestBody: UploadFileVersionRequestBody(attributes: UploadFileVersionRequestBodyAttributesField(name: newName), file: Utils.generateByteStream(size: 20)))
        let newFile: FileFull = newFiles.entries![0]
        XCTAssertTrue(newFile.name == newName)
        XCTAssertTrue(newFile.size == 20)
        let fileVersions: FileVersions = try await client.fileVersions.getFileVersions(fileId: file.id)
        XCTAssertTrue(fileVersions.totalCount == 1)
        let fileVersion: FileVersionFull = try await client.fileVersions.getFileVersionById(fileId: file.id, fileVersionId: fileVersions.entries![0].id)
        XCTAssertTrue(fileVersion.id == fileVersions.entries![0].id)
        try await client.fileVersions.promoteFileVersion(fileId: file.id, requestBody: PromoteFileVersionRequestBody(id: fileVersions.entries![0].id, type: PromoteFileVersionRequestBodyTypeField.fileVersion))
        let fileWithPromotedVersion: FileFull = try await client.files.getFileById(fileId: file.id)
        XCTAssertTrue(fileWithPromotedVersion.name == oldName)
        XCTAssertTrue(fileWithPromotedVersion.size == 10)
        try await client.fileVersions.deleteFileVersionById(fileId: file.id, fileVersionId: fileVersion.id)
        try await client.files.deleteFileById(fileId: file.id)
    }
}
