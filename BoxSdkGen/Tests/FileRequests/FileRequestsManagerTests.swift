import Foundation
import BoxSdkGen
import XCTest

class FileRequestsManagerTests: XCTestCase {

    public func testGetCopyUpdateDeleteFileRequest() async throws {
        let fileRequestId: String = Utils.getEnvironmentVariable(name: "BOX_FILE_REQUEST_ID")
        let userId: String = Utils.getEnvironmentVariable(name: "USER_ID")
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: userId)
        let fileRequest: FileRequest = try await client.fileRequests.getFileRequestById(fileRequestId: fileRequestId)
        XCTAssertTrue(fileRequest.id == fileRequestId)
        XCTAssertTrue(Utils.Strings.toString(value: fileRequest.type) == "file_request")
        let copiedFileRequest: FileRequest = try await client.fileRequests.createFileRequestCopy(fileRequestId: fileRequestId, requestBody: FileRequestCopyRequest(folder: FileRequestCopyRequestFolderField(id: fileRequest.folder.id, type: FileRequestCopyRequestFolderTypeField.folder)))
        XCTAssertTrue(copiedFileRequest.id != fileRequestId)
        XCTAssertTrue(copiedFileRequest.title == fileRequest.title)
        XCTAssertTrue(copiedFileRequest.description == fileRequest.description)
        let updatedFileRequest: FileRequest = try await client.fileRequests.updateFileRequestById(fileRequestId: copiedFileRequest.id, requestBody: FileRequestUpdateRequest(title: "updated title", description: "updated description"))
        XCTAssertTrue(updatedFileRequest.id == copiedFileRequest.id)
        XCTAssertTrue(updatedFileRequest.title == "updated title")
        XCTAssertTrue(updatedFileRequest.description == "updated description")
        try await client.fileRequests.deleteFileRequestById(fileRequestId: updatedFileRequest.id)
        await XCTAssertThrowsErrorAsync(try await client.fileRequests.getFileRequestById(fileRequestId: updatedFileRequest.id))
    }
}
