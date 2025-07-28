import Foundation
import BoxSdkGen
import XCTest

class HubItemsManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
    }

    public func testCreateDeleteGetHubItems() async throws {
        await runWithRetryAsync {
            let hubTitle: String = Utils.getUUID()
            let folder: FolderFull = try await client.folders.createFolder(requestBody: CreateFolderRequestBody(name: Utils.getUUID(), parent: CreateFolderRequestBodyParentField(id: "0")))
            let createdHub: HubV2025R0 = try await client.hubs.createHubV2025R0(requestBody: HubCreateRequestV2025R0(title: hubTitle))
            let hubItemsBeforeAdd: HubItemsV2025R0 = try await client.hubItems.getHubItemsV2025R0(queryParams: GetHubItemsV2025R0QueryParams(hubId: createdHub.id))
            XCTAssertTrue(hubItemsBeforeAdd.entries!.count == 0)
            try await client.hubs.deleteHubByIdV2025R0(hubId: createdHub.id)
            try await client.folders.deleteFolderById(folderId: folder.id)
        }
    }
}
