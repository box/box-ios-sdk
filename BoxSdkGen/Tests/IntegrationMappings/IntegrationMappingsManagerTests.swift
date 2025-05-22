import Foundation
import BoxSdkGen
import XCTest

class IntegrationMappingsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testSlackIntegrationMappings() async throws {
        let userId: String = Utils.getEnvironmentVariable(name: "USER_ID")
        let slackAutomationUserId: String = Utils.getEnvironmentVariable(name: "SLACK_AUTOMATION_USER_ID")
        let slackOrgId: String = Utils.getEnvironmentVariable(name: "SLACK_ORG_ID")
        let slackPartnerItemId: String = Utils.getEnvironmentVariable(name: "SLACK_PARTNER_ITEM_ID")
        let userClient: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: userId)
        let folder: FolderFull = try await userClient.folders.createFolder(requestBody: CreateFolderRequestBody(name: Utils.getUUID(), parent: CreateFolderRequestBodyParentField(id: "0")))
        try await userClient.userCollaborations.createCollaboration(requestBody: CreateCollaborationRequestBody(item: CreateCollaborationRequestBodyItemField(type: CreateCollaborationRequestBodyItemTypeField.folder, id: folder.id), accessibleBy: CreateCollaborationRequestBodyAccessibleByField(type: CreateCollaborationRequestBodyAccessibleByTypeField.user, id: slackAutomationUserId), role: CreateCollaborationRequestBodyRoleField.coOwner))
        let slackIntegrations: IntegrationMappings = try await userClient.integrationMappings.getSlackIntegrationMapping()
        if slackIntegrations.entries!.count == 0 {
            try await userClient.integrationMappings.createSlackIntegrationMapping(requestBody: IntegrationMappingSlackCreateRequest(partnerItem: IntegrationMappingPartnerItemSlack(id: slackPartnerItemId, slackOrgId: .value(slackOrgId)), boxItem: IntegrationMappingBoxItemSlack(id: folder.id)))
        }

        let slackMappings: IntegrationMappings = try await userClient.integrationMappings.getSlackIntegrationMapping()
        XCTAssertTrue(slackMappings.entries!.count >= 1)
        let slackIntegrationMapping: IntegrationMapping = slackMappings.entries![0]
        XCTAssertTrue(Utils.Strings.toString(value: slackIntegrationMapping.integrationType) == "slack")
        XCTAssertTrue(Utils.Strings.toString(value: slackIntegrationMapping.type) == "integration_mapping")
        XCTAssertTrue(Utils.Strings.toString(value: slackIntegrationMapping.boxItem.type) == "folder")
        let updatedSlackMapping: IntegrationMapping = try await userClient.integrationMappings.updateSlackIntegrationMappingById(integrationMappingId: slackIntegrationMapping.id, requestBody: UpdateSlackIntegrationMappingByIdRequestBody(boxItem: IntegrationMappingBoxItemSlack(id: folder.id)))
        XCTAssertTrue(Utils.Strings.toString(value: updatedSlackMapping.boxItem.type) == "folder")
        XCTAssertTrue(updatedSlackMapping.boxItem.id == folder.id)
        if slackMappings.entries!.count > 2 {
            try await userClient.integrationMappings.deleteSlackIntegrationMappingById(integrationMappingId: slackIntegrationMapping.id)
        }

        try await userClient.folders.deleteFolderById(folderId: folder.id)
    }

    public func testTeamsIntegrationMappings() async throws {
        let folder: FolderFull = try await client.folders.createFolder(requestBody: CreateFolderRequestBody(name: Utils.getUUID(), parent: CreateFolderRequestBodyParentField(id: "0")))
        let tenantId: String = "1"
        let teamId: String = "2"
        let partnerItemId: String = "3"
        let userId: String = Utils.getEnvironmentVariable(name: "USER_ID")
        let userClient: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: userId)
        await XCTAssertThrowsErrorAsync(try await userClient.integrationMappings.createTeamsIntegrationMapping(requestBody: IntegrationMappingTeamsCreateRequest(partnerItem: IntegrationMappingPartnerItemTeamsCreateRequest(type: IntegrationMappingPartnerItemTeamsCreateRequestTypeField.channel, id: partnerItemId, tenantId: tenantId, teamId: teamId), boxItem: FolderReference(id: folder.id))))
        await XCTAssertThrowsErrorAsync(try await userClient.integrationMappings.getTeamsIntegrationMapping())
        let integrationMappingId: String = "123456"
        await XCTAssertThrowsErrorAsync(try await userClient.integrationMappings.updateTeamsIntegrationMappingById(integrationMappingId: integrationMappingId, requestBody: UpdateTeamsIntegrationMappingByIdRequestBody(boxItem: FolderReference(id: "1234567"))))
        await XCTAssertThrowsErrorAsync(try await userClient.integrationMappings.deleteTeamsIntegrationMappingById(integrationMappingId: integrationMappingId))
        try await client.folders.deleteFolderById(folderId: folder.id)
    }
}
