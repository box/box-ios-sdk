import Foundation
import BoxSdkGen
import XCTest

class SharedLinksFilesManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testSharedLinksFiles() async throws {
        let uploadedFiles: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: Utils.getUUID(), parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: Utils.generateByteStream(size: 10)))
        let fileId: String = uploadedFiles.entries![0].id
        try await client.sharedLinksFiles.addShareLinkToFile(fileId: fileId, requestBody: AddShareLinkToFileRequestBody(sharedLink: AddShareLinkToFileRequestBodySharedLinkField(access: AddShareLinkToFileRequestBodySharedLinkAccessField.open, password: .value("Secret123@"))), queryParams: AddShareLinkToFileQueryParams(fields: "shared_link"))
        let fileFromApi: FileFull = try await client.sharedLinksFiles.getSharedLinkForFile(fileId: fileId, queryParams: GetSharedLinkForFileQueryParams(fields: "shared_link"))
        XCTAssertTrue(Utils.Strings.toString(value: fileFromApi.sharedLink!.access) == "open")
        let userId: String = Utils.getEnvironmentVariable(name: "USER_ID")
        let userClient: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: userId)
        let fileFromSharedLinkPassword: FileFull = try await userClient.sharedLinksFiles.findFileForSharedLink(queryParams: FindFileForSharedLinkQueryParams(), headers: FindFileForSharedLinkHeaders(boxapi: "\("shared_link=")\(fileFromApi.sharedLink!.url)\("&shared_link_password=Secret123@")"))
        XCTAssertTrue(fileId == fileFromSharedLinkPassword.id)
        await XCTAssertThrowsErrorAsync(try await userClient.sharedLinksFiles.findFileForSharedLink(queryParams: FindFileForSharedLinkQueryParams(), headers: FindFileForSharedLinkHeaders(boxapi: "\("shared_link=")\(fileFromApi.sharedLink!.url)\("&shared_link_password=incorrectPassword")")))
        let updatedFile: FileFull = try await client.sharedLinksFiles.updateSharedLinkOnFile(fileId: fileId, requestBody: UpdateSharedLinkOnFileRequestBody(sharedLink: UpdateSharedLinkOnFileRequestBodySharedLinkField(access: UpdateSharedLinkOnFileRequestBodySharedLinkAccessField.collaborators)), queryParams: UpdateSharedLinkOnFileQueryParams(fields: "shared_link"))
        XCTAssertTrue(Utils.Strings.toString(value: updatedFile.sharedLink!.access) == "collaborators")
        try await client.files.deleteFileById(fileId: fileId)
    }
}
