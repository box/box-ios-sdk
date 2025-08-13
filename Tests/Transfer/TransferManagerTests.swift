import Foundation
import BoxSdkGen
import XCTest

class TransferManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testTransferUserContent() async throws {
        await runWithRetryAsync {
            let sourceUserName: String = Utils.getUUID()
            let sourceUser: UserFull = try await client.users.createUser(requestBody: CreateUserRequestBody(name: sourceUserName, isPlatformAccessOnly: true))
            let targetUser: UserFull = try await client.users.getUserMe()
            let transferredFolder: FolderFull = try await client.transfer.transferOwnedFolder(userId: sourceUser.id, requestBody: TransferOwnedFolderRequestBody(ownedBy: TransferOwnedFolderRequestBodyOwnedByField(id: targetUser.id)), queryParams: TransferOwnedFolderQueryParams(notify: false))
            XCTAssertTrue(transferredFolder.ownedBy!.id == targetUser.id)
            try await client.folders.deleteFolderById(folderId: transferredFolder.id, queryParams: DeleteFolderByIdQueryParams(recursive: true))
            try await client.users.deleteUserById(userId: sourceUser.id, queryParams: DeleteUserByIdQueryParams(notify: false, force: true))
        }
    }
}
