import Foundation
import BoxSdkGen
import XCTest

class FileVersionRetentionsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testCreateUpdateGetDeleteRetentionPolicy() async throws {
        let description: String = Utils.getUUID()
        let retentionPolicy: RetentionPolicy = try await client.retentionPolicies.createRetentionPolicy(requestBody: CreateRetentionPolicyRequestBody(policyName: Utils.getUUID(), policyType: CreateRetentionPolicyRequestBodyPolicyTypeField.finite, dispositionAction: CreateRetentionPolicyRequestBodyDispositionActionField.removeRetention, description: description, retentionLength: "1", retentionType: CreateRetentionPolicyRequestBodyRetentionTypeField.modifiable, canOwnerExtendRetention: false))
        XCTAssertTrue(retentionPolicy.description == description)
        XCTAssertTrue(retentionPolicy.canOwnerExtendRetention == false)
        XCTAssertTrue(Utils.Strings.toString(value: retentionPolicy.retentionType) == "modifiable")
        let folder: FolderFull = try await CommonsManager().createNewFolder()
        let retentionPolicyAssignment: RetentionPolicyAssignment = try await client.retentionPolicyAssignments.createRetentionPolicyAssignment(requestBody: CreateRetentionPolicyAssignmentRequestBody(policyId: retentionPolicy.id, assignTo: CreateRetentionPolicyAssignmentRequestBodyAssignToField(type: CreateRetentionPolicyAssignmentRequestBodyAssignToTypeField.folder, id: .value(folder.id))))
        XCTAssertTrue(retentionPolicyAssignment.retentionPolicy!.id == retentionPolicy.id)
        XCTAssertTrue(retentionPolicyAssignment.assignedTo!.id == folder.id)
        XCTAssertTrue(Utils.Strings.toString(value: retentionPolicyAssignment.assignedTo!.type) == Utils.Strings.toString(value: folder.type))
        let files: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: Utils.getUUID(), parent: UploadFileRequestBodyAttributesParentField(id: folder.id)), file: Utils.generateByteStream(size: 10)))
        let file: FileFull = files.entries![0]
        let newFiles: Files = try await client.uploads.uploadFileVersion(fileId: file.id, requestBody: UploadFileVersionRequestBody(attributes: UploadFileVersionRequestBodyAttributesField(name: file.name!), file: Utils.generateByteStream(size: 20)))
        let newFile: FileFull = newFiles.entries![0]
        XCTAssertTrue(newFile.id == file.id)
        let fileVersionRetentions: FileVersionRetentions = try await client.fileVersionRetentions.getFileVersionRetentions()
        let fileVersionRetentionsCount: Int = fileVersionRetentions.entries!.count
        XCTAssertTrue(fileVersionRetentionsCount >= 0)
        if fileVersionRetentionsCount == 0 {
            try await client.retentionPolicies.deleteRetentionPolicyById(retentionPolicyId: retentionPolicy.id)
            try await client.folders.deleteFolderById(folderId: folder.id, queryParams: DeleteFolderByIdQueryParams(recursive: true))
            return
        }

        let fileVersionRetention: FileVersionRetention = fileVersionRetentions.entries![0]
        let fileVersionRetentionById: FileVersionRetention = try await client.fileVersionRetentions.getFileVersionRetentionById(fileVersionRetentionId: fileVersionRetention.id!)
        XCTAssertTrue(fileVersionRetentionById.id == fileVersionRetention.id)
        try await client.retentionPolicies.deleteRetentionPolicyById(retentionPolicyId: retentionPolicy.id)
        try await client.folders.deleteFolderById(folderId: folder.id, queryParams: DeleteFolderByIdQueryParams(recursive: true))
    }
}
