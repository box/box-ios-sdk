import Foundation
import BoxSdkGen
import XCTest

class UserCollaborationsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testUserCollaborations() async throws {
        let userName: String = Utils.getUUID()
        let userLogin: String = "\(Utils.getUUID())\("@gmail.com")"
        let user: UserFull = try await client.users.createUser(requestBody: CreateUserRequestBody(name: userName, login: userLogin, isPlatformAccessOnly: true))
        let folder: FolderFull = try await CommonsManager().createNewFolder()
        let collaboration: Collaboration = try await client.userCollaborations.createCollaboration(requestBody: CreateCollaborationRequestBody(item: CreateCollaborationRequestBodyItemField(type: CreateCollaborationRequestBodyItemTypeField.folder, id: folder.id), accessibleBy: CreateCollaborationRequestBodyAccessibleByField(type: CreateCollaborationRequestBodyAccessibleByTypeField.user, id: user.id), role: CreateCollaborationRequestBodyRoleField.editor))
        XCTAssertTrue(Utils.Strings.toString(value: collaboration.role!) == "editor")
        let collaborationId: String = collaboration.id
        let collaborationFromApi: Collaboration = try await client.userCollaborations.getCollaborationById(collaborationId: collaborationId)
        XCTAssertTrue(collaborationId == collaborationFromApi.id)
        XCTAssertTrue(Utils.Strings.toString(value: collaborationFromApi.status!) == "accepted")
        XCTAssertTrue(Utils.Strings.toString(value: collaborationFromApi.type) == "collaboration")
        XCTAssertTrue(collaborationFromApi.inviteEmail == nil)
        let updatedCollaboration: Collaboration? = try await client.userCollaborations.updateCollaborationById(collaborationId: collaborationId, requestBody: UpdateCollaborationByIdRequestBody(role: UpdateCollaborationByIdRequestBodyRoleField.viewer))
        XCTAssertTrue(Utils.Strings.toString(value: updatedCollaboration!.role!) == "viewer")
        try await client.userCollaborations.deleteCollaborationById(collaborationId: collaborationId)
        await XCTAssertThrowsErrorAsync(try await client.userCollaborations.getCollaborationById(collaborationId: collaborationId))
        try await client.folders.deleteFolderById(folderId: folder.id)
        try await client.users.deleteUserById(userId: user.id)
    }

    public func testConvertingUserCollaborationToOwnership() async throws {
        let userName: String = Utils.getUUID()
        let userLogin: String = "\(Utils.getUUID())\("@gmail.com")"
        let user: UserFull = try await client.users.createUser(requestBody: CreateUserRequestBody(name: userName, login: userLogin, isPlatformAccessOnly: true))
        let folder: FolderFull = try await CommonsManager().createNewFolder()
        let collaboration: Collaboration = try await client.userCollaborations.createCollaboration(requestBody: CreateCollaborationRequestBody(item: CreateCollaborationRequestBodyItemField(type: CreateCollaborationRequestBodyItemTypeField.folder, id: folder.id), accessibleBy: CreateCollaborationRequestBodyAccessibleByField(type: CreateCollaborationRequestBodyAccessibleByTypeField.user, id: user.id), role: CreateCollaborationRequestBodyRoleField.editor))
        XCTAssertTrue(Utils.Strings.toString(value: collaboration.role!) == "editor")
        let ownerCollaboration: Collaboration? = try await client.userCollaborations.updateCollaborationById(collaborationId: collaboration.id, requestBody: UpdateCollaborationByIdRequestBody(role: UpdateCollaborationByIdRequestBodyRoleField.owner))
        XCTAssertTrue(ownerCollaboration == nil)
        let folderCollaborations: Collaborations = try await client.listCollaborations.getFolderCollaborations(folderId: folder.id)
        let folderCollaboration: Collaboration = folderCollaborations.entries![0]
        try await client.userCollaborations.deleteCollaborationById(collaborationId: folderCollaboration.id)
        let userClient: BoxClient = client.withAsUserHeader(userId: user.id)
        try await userClient.folders.deleteFolderById(folderId: folder.id)
        try await userClient.trashedFolders.deleteTrashedFolderById(folderId: folder.id)
        try await client.users.deleteUserById(userId: user.id)
    }

    public func testExternalUserCollaborations() async throws {
        let userName: String = Utils.getUUID()
        let userLogin: String = "\(Utils.getUUID())\("@boxdemo.com")"
        let folder: FolderFull = try await CommonsManager().createNewFolder()
        let collaboration: Collaboration = try await client.userCollaborations.createCollaboration(requestBody: CreateCollaborationRequestBody(item: CreateCollaborationRequestBodyItemField(type: CreateCollaborationRequestBodyItemTypeField.folder, id: folder.id), accessibleBy: CreateCollaborationRequestBodyAccessibleByField(type: CreateCollaborationRequestBodyAccessibleByTypeField.user, login: userLogin), role: CreateCollaborationRequestBodyRoleField.editor))
        XCTAssertTrue(Utils.Strings.toString(value: collaboration.role!) == "editor")
        let collaborationId: String = collaboration.id
        let collaborationFromApi: Collaboration = try await client.userCollaborations.getCollaborationById(collaborationId: collaborationId)
        XCTAssertTrue(collaborationId == collaborationFromApi.id)
        XCTAssertTrue(Utils.Strings.toString(value: collaborationFromApi.status!) == "pending")
        XCTAssertTrue(Utils.Strings.toString(value: collaborationFromApi.type) == "collaboration")
        XCTAssertTrue(collaborationFromApi.inviteEmail == userLogin)
        let updatedCollaboration: Collaboration? = try await client.userCollaborations.updateCollaborationById(collaborationId: collaborationId, requestBody: UpdateCollaborationByIdRequestBody(role: UpdateCollaborationByIdRequestBodyRoleField.viewer))
        XCTAssertTrue(Utils.Strings.toString(value: updatedCollaboration!.role!) == "viewer")
        try await client.userCollaborations.deleteCollaborationById(collaborationId: collaborationId)
        await XCTAssertThrowsErrorAsync(try await client.userCollaborations.getCollaborationById(collaborationId: collaborationId))
        try await client.folders.deleteFolderById(folderId: folder.id)
    }
}
