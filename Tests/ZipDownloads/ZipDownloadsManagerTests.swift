import Foundation
import BoxSdkGen
import XCTest

class ZipDownloadsManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testZipDownload() async throws {
        await runWithRetryAsync {
            let file1: FileFull = try await CommonsManager().uploadNewFile()
            let file2: FileFull = try await CommonsManager().uploadNewFile()
            let folder1: FolderFull = try await CommonsManager().createNewFolder()
            let destinationPathString: String = "\(Utils.temporaryDirectoryPath())\(Utils.getUUID())"
            try await client.zipDownloads.downloadZip(requestBody: ZipDownloadRequest(items: [ZipDownloadRequestItemsField(type: ZipDownloadRequestItemsTypeField.file, id: file1.id), ZipDownloadRequestItemsField(type: ZipDownloadRequestItemsTypeField.file, id: file2.id), ZipDownloadRequestItemsField(type: ZipDownloadRequestItemsTypeField.folder, id: folder1.id)], downloadFileName: "zip"), downloadDestinationUrl: URL(path: destinationPathString))
            XCTAssertTrue(Utils.bufferEquals(buffer1: Utils.readBufferFromFile(filePath: destinationPathString), buffer2: Utils.generateByteBuffer(size: 10)) == false)
            try await client.files.deleteFileById(fileId: file1.id)
            try await client.files.deleteFileById(fileId: file2.id)
            try await client.folders.deleteFolderById(folderId: folder1.id)
        }
    }

    public func testManualZipDownloadAndCheckStatus() async throws {
        await runWithRetryAsync {
            let file1: FileFull = try await CommonsManager().uploadNewFile()
            let file2: FileFull = try await CommonsManager().uploadNewFile()
            let folder1: FolderFull = try await CommonsManager().createNewFolder()
            let zipDownload: ZipDownload = try await client.zipDownloads.createZipDownload(requestBody: ZipDownloadRequest(items: [ZipDownloadRequestItemsField(type: ZipDownloadRequestItemsTypeField.file, id: file1.id), ZipDownloadRequestItemsField(type: ZipDownloadRequestItemsTypeField.file, id: file2.id), ZipDownloadRequestItemsField(type: ZipDownloadRequestItemsTypeField.folder, id: folder1.id)], downloadFileName: "zip"))
            XCTAssertTrue(zipDownload.downloadUrl != "")
            XCTAssertTrue(zipDownload.statusUrl != "")
            XCTAssertTrue(Utils.Dates.dateTimeToString(dateTime: zipDownload.expiresAt!) != "")
            let destinationPathString: String = "\(Utils.temporaryDirectoryPath())\(Utils.getUUID())"
            try await client.zipDownloads.getZipDownloadContent(downloadUrl: zipDownload.downloadUrl!, downloadDestinationUrl: URL(path: destinationPathString))
            XCTAssertTrue(Utils.bufferEquals(buffer1: Utils.readBufferFromFile(filePath: destinationPathString), buffer2: Utils.generateByteBuffer(size: 10)) == false)
            let zipDownloadStatus: ZipDownloadStatus = try await client.zipDownloads.getZipDownloadStatus(statusUrl: zipDownload.statusUrl!)
            XCTAssertTrue(zipDownloadStatus.totalFileCount == 2)
            XCTAssertTrue(zipDownloadStatus.downloadedFileCount == 2)
            XCTAssertTrue(zipDownloadStatus.skippedFileCount == 0)
            XCTAssertTrue(zipDownloadStatus.skippedFolderCount == 0)
            XCTAssertTrue(Utils.Strings.toString(value: zipDownloadStatus.state) != "failed")
            try await client.files.deleteFileById(fileId: file1.id)
            try await client.files.deleteFileById(fileId: file2.id)
            try await client.folders.deleteFolderById(folderId: folder1.id)
        }
    }
}
