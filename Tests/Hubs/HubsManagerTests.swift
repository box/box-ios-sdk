import Foundation
import BoxSdkGen
import XCTest

class HubsManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
    }

    public func testCreateUpdateGetAndDeleteHubs() async throws {
        await runWithRetryAsync {
            let hubTitle: String = Utils.getUUID()
            let hubDescription: String = "new Hub description"
            let createdHub: HubV2025R0 = try await client.hubs.createHubV2025R0(requestBody: HubCreateRequestV2025R0(title: hubTitle, description: hubDescription))
            XCTAssertTrue(createdHub.title! == hubTitle)
            XCTAssertTrue(createdHub.description! == hubDescription)
            XCTAssertTrue(Utils.Strings.toString(value: createdHub.type) == "hubs")
            let hubId: String = createdHub.id
            let usersHubs: HubsV2025R0 = try await client.hubs.getHubsV2025R0(queryParams: GetHubsV2025R0QueryParams(scope: "all", sort: "name", direction: GetHubsV2025R0QueryParamsDirectionField.asc))
            XCTAssertTrue(usersHubs.entries!.count > 0)
            let enterpriseHubs: HubsV2025R0 = try await client.hubs.getEnterpriseHubsV2025R0(queryParams: GetEnterpriseHubsV2025R0QueryParams(sort: "name", direction: GetEnterpriseHubsV2025R0QueryParamsDirectionField.asc))
            XCTAssertTrue(enterpriseHubs.entries!.count > 0)
            let hubById: HubV2025R0 = try await client.hubs.getHubByIdV2025R0(hubId: hubId)
            XCTAssertTrue(hubById.id == hubId)
            XCTAssertTrue(hubById.title! == hubTitle)
            XCTAssertTrue(hubById.description! == hubDescription)
            XCTAssertTrue(Utils.Strings.toString(value: hubById.type) == "hubs")
            let newHubTitle: String = Utils.getUUID()
            let newHubDescription: String = "updated Hub description"
            let updatedHub: HubV2025R0 = try await client.hubs.updateHubByIdV2025R0(hubId: hubId, requestBody: HubUpdateRequestV2025R0(title: newHubTitle, description: newHubDescription))
            XCTAssertTrue(updatedHub.title! == newHubTitle)
            XCTAssertTrue(updatedHub.description! == newHubDescription)
            try await client.hubs.deleteHubByIdV2025R0(hubId: hubId)
            await XCTAssertThrowsErrorAsync(try await client.hubs.deleteHubByIdV2025R0(hubId: hubId))
        }
    }

    public func testCopyHub() async throws {
        await runWithRetryAsync {
            let hubTitle: String = Utils.getUUID()
            let hubDescription: String = "new Hub description"
            let createdHub: HubV2025R0 = try await client.hubs.createHubV2025R0(requestBody: HubCreateRequestV2025R0(title: hubTitle, description: hubDescription))
            let copiedHubTitle: String = Utils.getUUID()
            let copiedHubDescription: String = "copied Hub description"
            let copiedHub: HubV2025R0 = try await client.hubs.copyHubV2025R0(hubId: createdHub.id, requestBody: HubCopyRequestV2025R0(title: copiedHubTitle, description: copiedHubDescription))
            XCTAssertTrue(copiedHub.id != createdHub.id)
            XCTAssertTrue(copiedHub.title! == copiedHubTitle)
            XCTAssertTrue(copiedHub.description! == copiedHubDescription)
            try await client.hubs.deleteHubByIdV2025R0(hubId: createdHub.id)
            try await client.hubs.deleteHubByIdV2025R0(hubId: copiedHub.id)
        }
    }
}
