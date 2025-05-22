import Foundation
import BoxSdkGen
import XCTest

class FilesManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func uploadFile(fileName: String, fileStream: InputStream) async throws -> FileFull {
        let uploadedFiles: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: fileName, parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: fileStream))
        return uploadedFiles.entries![0]
    }

    public func testGetFileThumbnail() async throws {
        let thumbnailFileName: String = Utils.getUUID()
        let thumbnailBuffer: Data = Utils.generateByteBuffer(size: 1024 * 1024)
        let thumbnailContentStream: InputStream = Utils.generateByteStreamFromBuffer(buffer: thumbnailBuffer)
        let thumbnailFile: FileFull = try await uploadFile(fileName: thumbnailFileName, fileStream: thumbnailContentStream)
        let destinationPathString: String = "\(Utils.temporaryDirectoryPath())\(Utils.getUUID())"
        let destinationPath: URL = URL(path: destinationPathString)
        try await client.files.getFileThumbnailById(fileId: thumbnailFile.id, extension_: GetFileThumbnailByIdExtension.png, downloadDestinationUrl: destinationPath)
        XCTAssertTrue(Utils.bufferEquals(buffer1: Utils.readBufferFromFile(filePath: destinationPathString), buffer2: Utils.readByteStream(byteStream: thumbnailContentStream)) == false)
        try await client.files.deleteFileById(fileId: thumbnailFile.id)
    }

    public func testGetFileFullExtraFields() async throws {
        let newFileName: String = Utils.getUUID()
        let fileStream: InputStream = Utils.generateByteStream(size: 1024 * 1024)
        let uploadedFile: FileFull = try await uploadFile(fileName: newFileName, fileStream: fileStream)
        let file: FileFull = try await client.files.getFileById(fileId: uploadedFile.id, queryParams: GetFileByIdQueryParams(fields: ["is_externally_owned", "has_collaborations"]))
        XCTAssertTrue(file.isExternallyOwned == false)
        XCTAssertTrue(file.hasCollaborations == false)
        try await client.files.deleteFileById(fileId: file.id)
    }

    public func testCreateGetAndDeleteFile() async throws {
        let newFileName: String = Utils.getUUID()
        let updatedContentStream: InputStream = Utils.generateByteStream(size: 1024 * 1024)
        let uploadedFile: FileFull = try await uploadFile(fileName: newFileName, fileStream: updatedContentStream)
        let file: FileFull = try await client.files.getFileById(fileId: uploadedFile.id)
        await XCTAssertThrowsErrorAsync(try await client.files.getFileById(fileId: uploadedFile.id, queryParams: GetFileByIdQueryParams(fields: ["name"]), headers: GetFileByIdHeaders(extraHeaders: ["if-none-match": file.etag!])))
        XCTAssertTrue(file.name == newFileName)
        try await client.files.deleteFileById(fileId: uploadedFile.id)
        let trashedFile: TrashFile = try await client.trashedFiles.getTrashedFileById(fileId: uploadedFile.id)
        XCTAssertTrue(file.id == trashedFile.id)
    }

    public func testUpdateFile() async throws {
        let fileToUpdate: FileFull = try await CommonsManager().uploadNewFile()
        let updatedName: String = Utils.getUUID()
        let updatedFile: FileFull = try await client.files.updateFileById(fileId: fileToUpdate.id, requestBody: UpdateFileByIdRequestBody(name: updatedName, description: "Updated description"))
        XCTAssertTrue(updatedFile.name == updatedName)
        XCTAssertTrue(updatedFile.description == "Updated description")
        try await client.files.deleteFileById(fileId: updatedFile.id)
    }

    public func testFileLock() async throws {
        let file: FileFull = try await CommonsManager().uploadNewFile()
        let fileWithLock: FileFull = try await client.files.updateFileById(fileId: file.id, requestBody: UpdateFileByIdRequestBody(lock: .value(UpdateFileByIdRequestBodyLockField(access: UpdateFileByIdRequestBodyLockAccessField.lock))), queryParams: UpdateFileByIdQueryParams(fields: ["lock"]))
        XCTAssertTrue(fileWithLock.lock != nil)
        try await client.files.deleteFileById(fileId: file.id)
    }

    public func testCopyFile() async throws {
        let fileOrigin: FileFull = try await CommonsManager().uploadNewFile()
        let copiedFileName: String = Utils.getUUID()
        let copiedFile: FileFull = try await client.files.copyFile(fileId: fileOrigin.id, requestBody: CopyFileRequestBody(parent: CopyFileRequestBodyParentField(id: "0"), name: copiedFileName))
        XCTAssertTrue(copiedFile.parent!.id == "0")
        XCTAssertTrue(copiedFile.name == copiedFileName)
        try await client.files.deleteFileById(fileId: fileOrigin.id)
        try await client.files.deleteFileById(fileId: copiedFile.id)
    }
}
