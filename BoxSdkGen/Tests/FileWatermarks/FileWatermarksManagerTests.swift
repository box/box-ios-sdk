import Foundation
import BoxSdkGen
import XCTest

class FileWatermarksManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testCreateGetDeleteFileWatermark() async throws {
        let fileName: String = "\(Utils.getUUID())\(".txt")"
        let uploadedFiles: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: fileName, parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: Utils.generateByteStream(size: 10)))
        let file: FileFull = uploadedFiles.entries![0]
        let createdWatermark: Watermark = try await client.fileWatermarks.updateFileWatermark(fileId: file.id, requestBody: UpdateFileWatermarkRequestBody(watermark: UpdateFileWatermarkRequestBodyWatermarkField(imprint: UpdateFileWatermarkRequestBodyWatermarkImprintField.default_)))
        let watermark: Watermark = try await client.fileWatermarks.getFileWatermark(fileId: file.id)
        try await client.fileWatermarks.deleteFileWatermark(fileId: file.id)
        await XCTAssertThrowsErrorAsync(try await client.fileWatermarks.getFileWatermark(fileId: file.id))
        try await client.files.deleteFileById(fileId: file.id)
    }
}
