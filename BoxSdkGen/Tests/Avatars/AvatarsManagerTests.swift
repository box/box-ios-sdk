import Foundation
import BoxSdkGen
import XCTest

class AvatarsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testAvatars() async throws {
        let user: UserFull = try await client.users.getUserMe()
        let createdAvatar: UserAvatar = try await client.avatars.createUserAvatar(userId: user.id, requestBody: CreateUserAvatarRequestBody(pic: Utils.decodeBase64ByteStream(data: "iVBORw0KGgoAAAANSUhEUgAAAQAAAAEAAQMAAABmvDolAAAAA1BMVEW10NBjBBbqAAAAH0lEQVRoge3BAQ0AAADCoPdPbQ43oAAAAAAAAAAAvg0hAAABmmDh1QAAAABJRU5ErkJggg=="), picFileName: "avatar.png", picContentType: "image/png"))
        XCTAssertTrue(createdAvatar.picUrls!.small != nil)
        XCTAssertTrue(createdAvatar.picUrls!.large != nil)
        XCTAssertTrue(createdAvatar.picUrls!.preview != nil)
        let destinationPathString: String = "\(Utils.temporaryDirectoryPath())\(Utils.getUUID())"
        let destinationPath: URL = URL(path: destinationPathString)
        try await client.avatars.getUserAvatar(userId: user.id, downloadDestinationUrl: destinationPath)
        XCTAssertTrue(Utils.bufferEquals(buffer1: Utils.readBufferFromFile(filePath: destinationPathString), buffer2: Utils.generateByteBuffer(size: 0)) == false)
        try await client.avatars.deleteUserAvatar(userId: user.id)
        await XCTAssertThrowsErrorAsync(try await client.avatars.getUserAvatar(userId: user.id, downloadDestinationUrl: URL(path: "\(Utils.temporaryDirectoryPath())\(Utils.getUUID())")))
    }
}
