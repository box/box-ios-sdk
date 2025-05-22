import Foundation
import BoxSdkGen
import XCTest

class SharedLinksWebLinksManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testSharedLinksWebLinks() async throws {
        let parent: FolderFull = try await client.folders.getFolderById(folderId: "0")
        let webLink: WebLink = try await client.webLinks.createWebLink(requestBody: CreateWebLinkRequestBody(url: "https://www.box.com", parent: CreateWebLinkRequestBodyParentField(id: parent.id), name: Utils.getUUID(), description: "Weblink description"))
        let webLinkId: String = webLink.id
        try await client.sharedLinksWebLinks.addShareLinkToWebLink(webLinkId: webLinkId, requestBody: AddShareLinkToWebLinkRequestBody(sharedLink: AddShareLinkToWebLinkRequestBodySharedLinkField(access: AddShareLinkToWebLinkRequestBodySharedLinkAccessField.open, password: .value("Secret123@"))), queryParams: AddShareLinkToWebLinkQueryParams(fields: "shared_link"))
        let webLinkFromApi: WebLink = try await client.sharedLinksWebLinks.getSharedLinkForWebLink(webLinkId: webLinkId, queryParams: GetSharedLinkForWebLinkQueryParams(fields: "shared_link"))
        XCTAssertTrue(Utils.Strings.toString(value: webLinkFromApi.sharedLink!.access) == "open")
        let userId: String = Utils.getEnvironmentVariable(name: "USER_ID")
        let userClient: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: userId)
        let webLinkFromSharedLinkPassword: WebLink = try await userClient.sharedLinksWebLinks.findWebLinkForSharedLink(queryParams: FindWebLinkForSharedLinkQueryParams(), headers: FindWebLinkForSharedLinkHeaders(boxapi: "\("shared_link=")\(webLinkFromApi.sharedLink!.url)\("&shared_link_password=Secret123@")"))
        XCTAssertTrue(webLinkId == webLinkFromSharedLinkPassword.id)
        await XCTAssertThrowsErrorAsync(try await userClient.sharedLinksWebLinks.findWebLinkForSharedLink(queryParams: FindWebLinkForSharedLinkQueryParams(), headers: FindWebLinkForSharedLinkHeaders(boxapi: "\("shared_link=")\(webLinkFromApi.sharedLink!.url)\("&shared_link_password=incorrectPassword")")))
        let updatedWebLink: WebLink = try await client.sharedLinksWebLinks.updateSharedLinkOnWebLink(webLinkId: webLinkId, requestBody: UpdateSharedLinkOnWebLinkRequestBody(sharedLink: UpdateSharedLinkOnWebLinkRequestBodySharedLinkField(access: UpdateSharedLinkOnWebLinkRequestBodySharedLinkAccessField.collaborators)), queryParams: UpdateSharedLinkOnWebLinkQueryParams(fields: "shared_link"))
        XCTAssertTrue(Utils.Strings.toString(value: updatedWebLink.sharedLink!.access) == "collaborators")
        try await client.webLinks.deleteWebLinkById(webLinkId: webLinkId)
    }
}
