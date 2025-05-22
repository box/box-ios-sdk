import Foundation
import BoxSdkGen
import XCTest

class RetentionPolicyAssignmentsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testCreateUpdateGetDeleteRetentionPolicyAssignment() async throws {
        let retentionPolicyName: String = Utils.getUUID()
        let retentionDescription: String = "test description"
        let retentionPolicy: RetentionPolicy = try await client.retentionPolicies.createRetentionPolicy(requestBody: CreateRetentionPolicyRequestBody(policyName: retentionPolicyName, policyType: CreateRetentionPolicyRequestBodyPolicyTypeField.finite, dispositionAction: CreateRetentionPolicyRequestBodyDispositionActionField.removeRetention, description: retentionDescription, retentionLength: "1", retentionType: CreateRetentionPolicyRequestBodyRetentionTypeField.modifiable, canOwnerExtendRetention: true, areOwnersNotified: true))
        let folder: FolderFull = try await client.folders.createFolder(requestBody: CreateFolderRequestBody(name: Utils.getUUID(), parent: CreateFolderRequestBodyParentField(id: "0")))
        let files: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: Utils.getUUID(), parent: UploadFileRequestBodyAttributesParentField(id: folder.id)), file: Utils.generateByteStream(size: 10)))
        let file: FileFull = files.entries![0]
        let newVersions: Files = try await client.uploads.uploadFileVersion(fileId: file.id, requestBody: UploadFileVersionRequestBody(attributes: UploadFileVersionRequestBodyAttributesField(name: Utils.getUUID()), file: Utils.generateByteStream(size: 20)))
        let newVersion: FileFull = newVersions.entries![0]
        let retentionPolicyAssignment: RetentionPolicyAssignment = try await client.retentionPolicyAssignments.createRetentionPolicyAssignment(requestBody: CreateRetentionPolicyAssignmentRequestBody(policyId: retentionPolicy.id, assignTo: CreateRetentionPolicyAssignmentRequestBodyAssignToField(type: CreateRetentionPolicyAssignmentRequestBodyAssignToTypeField.folder, id: .value(folder.id))))
        XCTAssertTrue(retentionPolicyAssignment.retentionPolicy!.id == retentionPolicy.id)
        XCTAssertTrue(retentionPolicyAssignment.assignedTo!.id == folder.id)
        let retentionPolicyAssignmentById: RetentionPolicyAssignment = try await client.retentionPolicyAssignments.getRetentionPolicyAssignmentById(retentionPolicyAssignmentId: retentionPolicyAssignment.id)
        XCTAssertTrue(retentionPolicyAssignmentById.id == retentionPolicyAssignment.id)
        let retentionPolicyAssignments: RetentionPolicyAssignments = try await client.retentionPolicyAssignments.getRetentionPolicyAssignments(retentionPolicyId: retentionPolicy.id)
        XCTAssertTrue(retentionPolicyAssignments.entries!.count == 1)
        let filesUnderRetention: FilesUnderRetention = try await client.retentionPolicyAssignments.getFilesUnderRetentionPolicyAssignment(retentionPolicyAssignmentId: retentionPolicyAssignment.id)
        XCTAssertTrue(filesUnderRetention.entries!.count == 1)
        try await client.retentionPolicyAssignments.deleteRetentionPolicyAssignmentById(retentionPolicyAssignmentId: retentionPolicyAssignment.id)
        let retentionPolicyAssignmentsAfterDelete: RetentionPolicyAssignments = try await client.retentionPolicyAssignments.getRetentionPolicyAssignments(retentionPolicyId: retentionPolicy.id)
        XCTAssertTrue(retentionPolicyAssignmentsAfterDelete.entries!.count == 0)
        try await client.retentionPolicies.deleteRetentionPolicyById(retentionPolicyId: retentionPolicy.id)
        try await client.files.deleteFileById(fileId: file.id)
    }
}
