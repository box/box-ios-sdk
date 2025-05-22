import Foundation
import BoxSdkGen
import XCTest

class MetadataCascadePoliciesManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testMetadataCascadePolicies() async throws {
        let templateKey: String = "\("key")\(Utils.getUUID())"
        try await client.metadataTemplates.createMetadataTemplate(requestBody: CreateMetadataTemplateRequestBody(scope: "enterprise", displayName: templateKey, templateKey: templateKey, fields: [CreateMetadataTemplateRequestBodyFieldsField(type: CreateMetadataTemplateRequestBodyFieldsTypeField.string, key: "testName", displayName: "testName")]))
        let folder: FolderFull = try await CommonsManager().createNewFolder()
        let enterpriseId: String = Utils.getEnvironmentVariable(name: "ENTERPRISE_ID")
        let cascadePolicy: MetadataCascadePolicy = try await client.metadataCascadePolicies.createMetadataCascadePolicy(requestBody: CreateMetadataCascadePolicyRequestBody(folderId: folder.id, scope: CreateMetadataCascadePolicyRequestBodyScopeField.enterprise, templateKey: templateKey))
        XCTAssertTrue(Utils.Strings.toString(value: cascadePolicy.type) == "metadata_cascade_policy")
        XCTAssertTrue(Utils.Strings.toString(value: cascadePolicy.ownerEnterprise!.type!) == "enterprise")
        XCTAssertTrue(Utils.Strings.toString(value: cascadePolicy.ownerEnterprise!.id!) == enterpriseId)
        XCTAssertTrue(Utils.Strings.toString(value: cascadePolicy.parent!.type!) == "folder")
        XCTAssertTrue(cascadePolicy.parent!.id! == folder.id)
        XCTAssertTrue(Utils.Strings.toString(value: cascadePolicy.scope!) == "\("enterprise_")\(enterpriseId)")
        XCTAssertTrue(cascadePolicy.templateKey! == templateKey)
        let cascadePolicyId: String = cascadePolicy.id
        let policyFromTheApi: MetadataCascadePolicy = try await client.metadataCascadePolicies.getMetadataCascadePolicyById(metadataCascadePolicyId: cascadePolicyId)
        XCTAssertTrue(cascadePolicyId == policyFromTheApi.id)
        let policies: MetadataCascadePolicies = try await client.metadataCascadePolicies.getMetadataCascadePolicies(queryParams: GetMetadataCascadePoliciesQueryParams(folderId: folder.id))
        XCTAssertTrue(policies.entries!.count == 1)
        await XCTAssertThrowsErrorAsync(try await client.metadataCascadePolicies.applyMetadataCascadePolicy(metadataCascadePolicyId: cascadePolicyId, requestBody: ApplyMetadataCascadePolicyRequestBody(conflictResolution: ApplyMetadataCascadePolicyRequestBodyConflictResolutionField.overwrite)))
        try await client.folderMetadata.createFolderMetadataById(folderId: folder.id, scope: CreateFolderMetadataByIdScope.enterprise, templateKey: templateKey, requestBody: ["testName": "xyz"])
        try await client.metadataCascadePolicies.applyMetadataCascadePolicy(metadataCascadePolicyId: cascadePolicyId, requestBody: ApplyMetadataCascadePolicyRequestBody(conflictResolution: ApplyMetadataCascadePolicyRequestBodyConflictResolutionField.overwrite))
        try await client.metadataCascadePolicies.deleteMetadataCascadePolicyById(metadataCascadePolicyId: cascadePolicyId)
        await XCTAssertThrowsErrorAsync(try await client.metadataCascadePolicies.getMetadataCascadePolicyById(metadataCascadePolicyId: cascadePolicyId))
        try await client.metadataTemplates.deleteMetadataTemplate(scope: DeleteMetadataTemplateScope.enterprise, templateKey: templateKey)
        try await client.folders.deleteFolderById(folderId: folder.id)
    }
}
