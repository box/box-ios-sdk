import Foundation
import BoxSdkGen
import XCTest

class HubCollaborationsManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
    }

    public func testCrudHubCollaboration() async throws {
        await runWithRetryAsync {
            let hubs: HubsV2025R0 = try await client.hubs.getHubsV2025R0(queryParams: GetHubsV2025R0QueryParams(scope: "all", sort: "name", direction: GetHubsV2025R0QueryParamsDirectionField.asc))
            let hub: HubV2025R0 = hubs.entries![0]
            let userName: String = Utils.getUUID()
            let userLogin: String = "\(Utils.getUUID())\("@gmail.com")"
            let user: UserFull = try await client.users.createUser(requestBody: CreateUserRequestBody(name: userName, login: userLogin, isPlatformAccessOnly: true))
            let createdCollaboration: HubCollaborationV2025R0 = try await client.hubCollaborations.createHubCollaborationV2025R0(requestBody: HubCollaborationCreateRequestV2025R0(hub: HubCollaborationCreateRequestV2025R0HubField(id: hub.id), accessibleBy: HubCollaborationCreateRequestV2025R0AccessibleByField(type: "user", id: user.id), role: "viewer"))
            XCTAssertTrue(createdCollaboration.id != "")
            XCTAssertTrue(Utils.Strings.toString(value: createdCollaboration.type) == "hub_collaboration")
            XCTAssertTrue(createdCollaboration.hub!.id == hub.id)
            XCTAssertTrue(createdCollaboration.role == "viewer")
            let updatedCollaboration: HubCollaborationV2025R0 = try await client.hubCollaborations.updateHubCollaborationByIdV2025R0(hubCollaborationId: createdCollaboration.id, requestBody: HubCollaborationUpdateRequestV2025R0(role: "editor"))
            XCTAssertTrue(updatedCollaboration.id != "")
            XCTAssertTrue(Utils.Strings.toString(value: updatedCollaboration.type) == "hub_collaboration")
            XCTAssertTrue(updatedCollaboration.hub!.id == hub.id)
            XCTAssertTrue(updatedCollaboration.role == "editor")
            let collaborations: HubCollaborationsV2025R0 = try await client.hubCollaborations.getHubCollaborationsV2025R0(queryParams: GetHubCollaborationsV2025R0QueryParams(hubId: hub.id))
            XCTAssertTrue(collaborations.entries!.count >= 1)
            let retrievedCollaboration: HubCollaborationV2025R0 = try await client.hubCollaborations.getHubCollaborationByIdV2025R0(hubCollaborationId: createdCollaboration.id)
            XCTAssertTrue(retrievedCollaboration.id == createdCollaboration.id)
            XCTAssertTrue(Utils.Strings.toString(value: retrievedCollaboration.type) == "hub_collaboration")
            XCTAssertTrue(retrievedCollaboration.hub!.id == hub.id)
            XCTAssertTrue(retrievedCollaboration.role == "editor")
            try await client.hubCollaborations.deleteHubCollaborationByIdV2025R0(hubCollaborationId: createdCollaboration.id)
            try await client.users.deleteUserById(userId: user.id)
        }
    }
}
