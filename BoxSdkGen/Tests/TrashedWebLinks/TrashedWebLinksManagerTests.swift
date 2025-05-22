import Foundation
import BoxSdkGen
import XCTest

class TrashedWebLinksManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testTrashedWebLinks() async throws {
        let url: String = "https://www.box.com"
        let parent: FolderFull = try await client.folders.getFolderById(folderId: "0")
        let name: String = Utils.getUUID()
        let description: String = "Weblink description"
        let weblink: WebLink = try await client.webLinks.createWebLink(requestBody: CreateWebLinkRequestBody(url: url, parent: CreateWebLinkRequestBodyParentField(id: parent.id), name: name, description: description))
        try await client.webLinks.deleteWebLinkById(webLinkId: weblink.id)
        let fromTrash: TrashWebLink = try await client.trashedWebLinks.getTrashedWebLinkById(webLinkId: weblink.id)
        XCTAssertTrue(fromTrash.id == weblink.id)
        XCTAssertTrue(fromTrash.name == weblink.name)
        let fromApiAfterTrashed: WebLink = try await client.webLinks.getWebLinkById(webLinkId: weblink.id)
        XCTAssertTrue(Utils.Strings.toString(value: fromApiAfterTrashed.itemStatus) == "trashed")
        let restoredWeblink: TrashWebLinkRestored = try await client.trashedWebLinks.restoreWeblinkFromTrash(webLinkId: weblink.id)
        let fromApi: WebLink = try await client.webLinks.getWebLinkById(webLinkId: weblink.id)
        XCTAssertTrue(restoredWeblink.id == fromApi.id)
        XCTAssertTrue(restoredWeblink.name == fromApi.name)
        try await client.webLinks.deleteWebLinkById(webLinkId: weblink.id)
        try await client.trashedWebLinks.deleteTrashedWebLinkById(webLinkId: weblink.id)
        await XCTAssertThrowsErrorAsync(try await client.trashedWebLinks.getTrashedWebLinkById(webLinkId: weblink.id))
    }
}
