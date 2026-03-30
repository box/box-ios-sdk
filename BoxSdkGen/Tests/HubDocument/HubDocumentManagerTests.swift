import Foundation
import BoxSdkGen
import XCTest

class HubDocumentManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
    }

    public func testGetHubDocumentPagesAndBlocks() async throws {
        await runWithRetryAsync {
            let hubTitle: String = Utils.getUUID()
            let createdHub: HubV2025R0 = try await client.hubs.createHubV2025R0(requestBody: HubCreateRequestV2025R0(title: hubTitle))
            let hubId: String = createdHub.id
            let pages: HubDocumentPagesV2025R0 = try await client.hubDocument.getHubDocumentPagesV2025R0(queryParams: GetHubDocumentPagesV2025R0QueryParams(hubId: hubId))
            XCTAssertTrue(pages.entries.count > 0)
            XCTAssertTrue(Utils.Strings.toString(value: pages.type) == "document_pages")
            let firstPage: HubDocumentPageV2025R0 = pages.entries[0]
            XCTAssertTrue(Utils.Strings.toString(value: firstPage.type) == "page")
            let pageId: String = firstPage.id
            let blocks: HubDocumentBlocksV2025R0 = try await client.hubDocument.getHubDocumentBlocksV2025R0(queryParams: GetHubDocumentBlocksV2025R0QueryParams(hubId: hubId, pageId: pageId))
            XCTAssertTrue(Utils.Strings.toString(value: blocks.type) == "document_blocks")
            XCTAssertTrue(blocks.entries.count > 0)
            try await client.hubs.deleteHubByIdV2025R0(hubId: hubId)
        }
    }
}
