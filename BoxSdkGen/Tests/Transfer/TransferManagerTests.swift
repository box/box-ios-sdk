import Foundation
import BoxSdkGen
import XCTest

class TransferManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testTransferUserContent() async throws {
        let newUserName: String = Utils.getUUID()
        let newUser: UserFull = try await client.users.createUser(requestBody: CreateUserRequestBody(name: newUserName, isPlatformAccessOnly: true))
        let currentUser: UserFull = try await client.users.getUserMe()
        let transferedFolder: FolderFull = try await client.transfer.transferOwnedFolder(userId: newUser.id, requestBody: TransferOwnedFolderRequestBody(ownedBy: TransferOwnedFolderRequestBodyOwnedByField(id: currentUser.id)), queryParams: TransferOwnedFolderQueryParams(notify: false))
        XCTAssertTrue(transferedFolder.ownedBy!.id == currentUser.id)
        try await client.folders.deleteFolderById(folderId: transferedFolder.id, queryParams: DeleteFolderByIdQueryParams(recursive: true))
        try await client.users.deleteUserById(userId: newUser.id, queryParams: DeleteUserByIdQueryParams(notify: false, force: true))
    }
}
