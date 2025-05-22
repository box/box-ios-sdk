import Foundation
import BoxSdkGen
import XCTest

class WeblinksManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testCreateGetDeleteWeblink() async throws {
        let url: String = "https://www.box.com"
        let parent: FolderFull = try await client.folders.getFolderById(folderId: "0")
        let name: String = Utils.getUUID()
        let description: String = "Weblink description"
        let password: String = "super-secret-password"
        let weblink: WebLink = try await client.webLinks.createWebLink(requestBody: CreateWebLinkRequestBody(url: url, parent: CreateWebLinkRequestBodyParentField(id: parent.id), name: name, description: description))
        XCTAssertTrue(weblink.url == url)
        XCTAssertTrue(weblink.parent!.id == parent.id)
        XCTAssertTrue(weblink.name == name)
        XCTAssertTrue(weblink.description == description)
        let weblinkById: WebLink = try await client.webLinks.getWebLinkById(webLinkId: weblink.id)
        XCTAssertTrue(weblinkById.id == weblink.id)
        XCTAssertTrue(weblinkById.url == url)
        let updatedName: String = Utils.getUUID()
        let updatedWeblink: WebLink = try await client.webLinks.updateWebLinkById(webLinkId: weblink.id, requestBody: UpdateWebLinkByIdRequestBody(name: updatedName, sharedLink: UpdateWebLinkByIdRequestBodySharedLinkField(access: UpdateWebLinkByIdRequestBodySharedLinkAccessField.open, password: .value(password))))
        XCTAssertTrue(updatedWeblink.name == updatedName)
        XCTAssertTrue(Utils.Strings.toString(value: updatedWeblink.sharedLink!.access!) == "open")
        try await client.webLinks.deleteWebLinkById(webLinkId: weblink.id)
        let deletedWeblink: WebLink = try await client.webLinks.getWebLinkById(webLinkId: weblink.id)
        XCTAssertTrue(Utils.Strings.toString(value: deletedWeblink.itemStatus!) == "trashed")
    }
}
