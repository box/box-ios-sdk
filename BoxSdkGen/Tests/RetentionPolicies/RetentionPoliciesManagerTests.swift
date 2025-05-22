import Foundation
import BoxSdkGen
import XCTest

class RetentionPoliciesManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testCreateUpdateGetDeleteRetentionPolicy() async throws {
        let retentionPolicyName: String = Utils.getUUID()
        let retentionDescription: String = "test description"
        let retentionPolicy: RetentionPolicy = try await client.retentionPolicies.createRetentionPolicy(requestBody: CreateRetentionPolicyRequestBody(policyName: retentionPolicyName, policyType: CreateRetentionPolicyRequestBodyPolicyTypeField.finite, dispositionAction: CreateRetentionPolicyRequestBodyDispositionActionField.removeRetention, description: retentionDescription, retentionLength: "1", retentionType: CreateRetentionPolicyRequestBodyRetentionTypeField.modifiable, canOwnerExtendRetention: true, areOwnersNotified: true))
        XCTAssertTrue(retentionPolicy.policyName == retentionPolicyName)
        XCTAssertTrue(retentionPolicy.description == retentionDescription)
        let retentionPolicyById: RetentionPolicy = try await client.retentionPolicies.getRetentionPolicyById(retentionPolicyId: retentionPolicy.id)
        XCTAssertTrue(retentionPolicyById.id == retentionPolicy.id)
        let retentionPolicies: RetentionPolicies = try await client.retentionPolicies.getRetentionPolicies()
        XCTAssertTrue(retentionPolicies.entries!.count > 0)
        let updatedRetentionPolicyName: String = Utils.getUUID()
        let updatedRetentionPolicy: RetentionPolicy = try await client.retentionPolicies.updateRetentionPolicyById(retentionPolicyId: retentionPolicy.id, requestBody: UpdateRetentionPolicyByIdRequestBody(policyName: .value(updatedRetentionPolicyName)))
        XCTAssertTrue(updatedRetentionPolicy.policyName == updatedRetentionPolicyName)
        try await client.retentionPolicies.deleteRetentionPolicyById(retentionPolicyId: retentionPolicy.id)
    }
}
