import Foundation
import BoxSdkGen
import XCTest

class SharedLinksFoldersManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testSharedLinksFolders() async throws {
        let folder: FolderFull = try await client.folders.createFolder(requestBody: CreateFolderRequestBody(name: Utils.getUUID(), parent: CreateFolderRequestBodyParentField(id: "0")))
        try await client.sharedLinksFolders.addShareLinkToFolder(folderId: folder.id, requestBody: AddShareLinkToFolderRequestBody(sharedLink: AddShareLinkToFolderRequestBodySharedLinkField(access: AddShareLinkToFolderRequestBodySharedLinkAccessField.open, password: .value("Secret123@"))), queryParams: AddShareLinkToFolderQueryParams(fields: "shared_link"))
        let folderFromApi: FolderFull = try await client.sharedLinksFolders.getSharedLinkForFolder(folderId: folder.id, queryParams: GetSharedLinkForFolderQueryParams(fields: "shared_link"))
        XCTAssertTrue(Utils.Strings.toString(value: folderFromApi.sharedLink!.access) == "open")
        let userId: String = Utils.getEnvironmentVariable(name: "USER_ID")
        let userClient: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: userId)
        let folderFromSharedLinkPassword: FolderFull = try await userClient.sharedLinksFolders.findFolderForSharedLink(queryParams: FindFolderForSharedLinkQueryParams(), headers: FindFolderForSharedLinkHeaders(boxapi: "\("shared_link=")\(folderFromApi.sharedLink!.url)\("&shared_link_password=Secret123@")"))
        XCTAssertTrue(folder.id == folderFromSharedLinkPassword.id)
        await XCTAssertThrowsErrorAsync(try await userClient.sharedLinksFolders.findFolderForSharedLink(queryParams: FindFolderForSharedLinkQueryParams(), headers: FindFolderForSharedLinkHeaders(boxapi: "\("shared_link=")\(folderFromApi.sharedLink!.url)\("&shared_link_password=incorrectPassword")")))
        let updatedFolder: FolderFull = try await client.sharedLinksFolders.updateSharedLinkOnFolder(folderId: folder.id, requestBody: UpdateSharedLinkOnFolderRequestBody(sharedLink: UpdateSharedLinkOnFolderRequestBodySharedLinkField(access: UpdateSharedLinkOnFolderRequestBodySharedLinkAccessField.collaborators)), queryParams: UpdateSharedLinkOnFolderQueryParams(fields: "shared_link"))
        XCTAssertTrue(Utils.Strings.toString(value: updatedFolder.sharedLink!.access) == "collaborators")
        try await client.folders.deleteFolderById(folderId: folder.id)
    }
}
