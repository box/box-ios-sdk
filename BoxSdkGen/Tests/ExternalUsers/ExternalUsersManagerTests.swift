import Foundation
import BoxSdkGen
import XCTest

class ExternalUsersManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
    }

    public func testSubmitJobToDeleteExternalUsers() async throws {
        await runWithRetryAsync {
            let file: FileFull = try await CommonsManager().uploadNewFile()
            let fileCollaboration: Collaboration = try await client.userCollaborations.createCollaboration(requestBody: CreateCollaborationRequestBody(item: CreateCollaborationRequestBodyItemField(type: CreateCollaborationRequestBodyItemTypeField.file, id: file.id), accessibleBy: CreateCollaborationRequestBodyAccessibleByField(type: CreateCollaborationRequestBodyAccessibleByTypeField.user, id: Utils.getEnvironmentVariable(name: "BOX_EXTERNAL_USER_ID")), role: CreateCollaborationRequestBodyRoleField.editor))
            let externalUsersJobDeleteResponse: ExternalUsersSubmitDeleteJobResponseV2025R0 = try await client.externalUsers.submitJobToDeleteExternalUsersV2025R0(requestBody: ExternalUsersSubmitDeleteJobRequestV2025R0(externalUsers: [UserReferenceV2025R0(id: Utils.getEnvironmentVariable(name: "BOX_EXTERNAL_USER_ID"))]))
            XCTAssertTrue(externalUsersJobDeleteResponse.entries.count == 1)
            XCTAssertTrue(externalUsersJobDeleteResponse.entries[0].status == 202)
            try await client.files.deleteFileById(fileId: file.id)
        }
    }
}
