import Foundation
import BoxSdkGen
import XCTest

class ListCollaborationsManagerTests: XCTestCase {

    public func testListCollaborations() async throws {
        let client: BoxClient = CommonsManager().getDefaultClient()
        let folder: FolderFull = try await CommonsManager().createNewFolder()
        let file: FileFull = try await CommonsManager().uploadNewFile()
        let group: GroupFull = try await client.groups.createGroup(requestBody: CreateGroupRequestBody(name: Utils.getUUID()))
        let groupCollaboration: Collaboration = try await client.userCollaborations.createCollaboration(requestBody: CreateCollaborationRequestBody(item: CreateCollaborationRequestBodyItemField(type: CreateCollaborationRequestBodyItemTypeField.folder, id: folder.id), accessibleBy: CreateCollaborationRequestBodyAccessibleByField(type: CreateCollaborationRequestBodyAccessibleByTypeField.group, id: group.id), role: CreateCollaborationRequestBodyRoleField.editor))
        let fileCollaboration: Collaboration = try await client.userCollaborations.createCollaboration(requestBody: CreateCollaborationRequestBody(item: CreateCollaborationRequestBodyItemField(type: CreateCollaborationRequestBodyItemTypeField.file, id: file.id), accessibleBy: CreateCollaborationRequestBodyAccessibleByField(type: CreateCollaborationRequestBodyAccessibleByTypeField.user, id: Utils.getEnvironmentVariable(name: "USER_ID")), role: CreateCollaborationRequestBodyRoleField.editor))
        XCTAssertTrue(Utils.Strings.toString(value: groupCollaboration.role) == "editor")
        XCTAssertTrue(Utils.Strings.toString(value: groupCollaboration.type) == "collaboration")
        let fileCollaborations: Collaborations = try await client.listCollaborations.getFileCollaborations(fileId: file.id)
        XCTAssertTrue(fileCollaborations.entries!.count > 0)
        let folderCollaborations: Collaborations = try await client.listCollaborations.getFolderCollaborations(folderId: folder.id)
        XCTAssertTrue(folderCollaborations.entries!.count > 0)
        let pendingCollaborations: CollaborationsOffsetPaginated = try await client.listCollaborations.getCollaborations(queryParams: GetCollaborationsQueryParams(status: GetCollaborationsQueryParamsStatusField.pending))
        XCTAssertTrue(pendingCollaborations.entries!.count >= 0)
        let groupCollaborations: CollaborationsOffsetPaginated = try await client.listCollaborations.getGroupCollaborations(groupId: group.id)
        XCTAssertTrue(groupCollaborations.entries!.count > 0)
        try await client.userCollaborations.deleteCollaborationById(collaborationId: groupCollaboration.id)
        try await client.files.deleteFileById(fileId: file.id)
        try await client.folders.deleteFolderById(folderId: folder.id)
        try await client.groups.deleteGroupById(groupId: group.id)
    }
}
