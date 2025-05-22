import Foundation
import BoxSdkGen
import XCTest

class EmailAliasesManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testEmailAliases() async throws {
        let newUserName: String = Utils.getUUID()
        let newUserLogin: String = "\(Utils.getUUID())\("@boxdemo.com")"
        let newUser: UserFull = try await client.users.createUser(requestBody: CreateUserRequestBody(name: newUserName, login: newUserLogin))
        let aliases: EmailAliases = try await client.emailAliases.getUserEmailAliases(userId: newUser.id)
        XCTAssertTrue(aliases.totalCount == 0)
        let newAliasEmail: String = "\(newUser.id)\("@boxdemo.com")"
        let newAlias: EmailAlias = try await client.emailAliases.createUserEmailAlias(userId: newUser.id, requestBody: CreateUserEmailAliasRequestBody(email: newAliasEmail))
        let updatedAliases: EmailAliases = try await client.emailAliases.getUserEmailAliases(userId: newUser.id)
        XCTAssertTrue(updatedAliases.totalCount == 1)
        XCTAssertTrue(updatedAliases.entries![0].email == newAliasEmail)
        try await client.emailAliases.deleteUserEmailAliasById(userId: newUser.id, emailAliasId: newAlias.id!)
        let finalAliases: EmailAliases = try await client.emailAliases.getUserEmailAliases(userId: newUser.id)
        XCTAssertTrue(finalAliases.totalCount == 0)
        try await client.users.deleteUserById(userId: newUser.id)
    }
}
