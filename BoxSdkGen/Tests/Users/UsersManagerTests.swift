import Foundation
import BoxSdkGen
import XCTest

class UsersManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testGetUsers() async throws {
        let users: Users = try await client.users.getUsers()
        XCTAssertTrue(users.totalCount! >= 0)
    }

    public func testGetUserMe() async throws {
        let currentUser: UserFull = try await client.users.getUserMe()
        XCTAssertTrue(Utils.Strings.toString(value: currentUser.type) == "user")
    }

    public func testCreateUpdateGetDeleteUser() async throws {
        let userName: String = Utils.getUUID()
        let userLogin: String = "\(Utils.getUUID())\("@gmail.com")"
        let user: UserFull = try await client.users.createUser(requestBody: CreateUserRequestBody(name: userName, login: userLogin, isPlatformAccessOnly: true))
        XCTAssertTrue(user.name == userName)
        let userById: UserFull = try await client.users.getUserById(userId: user.id)
        XCTAssertTrue(userById.id == user.id)
        let updatedUserName: String = Utils.getUUID()
        let updatedUser: UserFull = try await client.users.updateUserById(userId: user.id, requestBody: UpdateUserByIdRequestBody(name: updatedUserName))
        XCTAssertTrue(updatedUser.name == updatedUserName)
        try await client.users.deleteUserById(userId: user.id)
    }
}
