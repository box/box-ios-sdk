import Foundation
import BoxSdkGen
import XCTest

class DownloadsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testDownloadFile() async throws {
        let newFileName: String = Utils.getUUID()
        let fileBuffer: Data = Utils.generateByteBuffer(size: 1024 * 1024)
        let fileContentStream: InputStream = Utils.generateByteStreamFromBuffer(buffer: fileBuffer)
        let uploadedFiles: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: newFileName, parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: fileContentStream))
        let uploadedFile: FileFull = uploadedFiles.entries![0]
        let destinationPathString: String = "\(Utils.temporaryDirectoryPath())\(Utils.getUUID())"
        try await client.downloads.downloadFile(fileId: uploadedFile.id, downloadDestinationUrl: URL(path: destinationPathString))
        XCTAssertTrue(Utils.bufferEquals(buffer1: Utils.readBufferFromFile(filePath: destinationPathString), buffer2: fileBuffer))
        try await client.files.deleteFileById(fileId: uploadedFile.id)
    }
}
