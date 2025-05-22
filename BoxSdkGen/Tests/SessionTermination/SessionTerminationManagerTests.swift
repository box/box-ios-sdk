import Foundation
import BoxSdkGen
import XCTest

class SessionTerminationManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testSessionTerminationUser() async throws {
        let adminClient: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
        let user: UserFull = try await adminClient.users.getUserMe()
        let result: SessionTerminationMessage = try await client.sessionTermination.terminateUsersSessions(requestBody: TerminateUsersSessionsRequestBody(userIds: [Utils.getEnvironmentVariable(name: "USER_ID")], userLogins: [user.login!]))
        XCTAssertTrue(result.message == "Request is successful, please check the admin events for the status of the job")
    }

    public func testSessionTerminationGroup() async throws {
        let groupName: String = Utils.getUUID()
        let group: GroupFull = try await client.groups.createGroup(requestBody: CreateGroupRequestBody(name: groupName))
        let result: SessionTerminationMessage = try await client.sessionTermination.terminateGroupsSessions(requestBody: TerminateGroupsSessionsRequestBody(groupIds: [group.id]))
        XCTAssertTrue(result.message == "Request is successful, please check the admin events for the status of the job")
        try await client.groups.deleteGroupById(groupId: group.id)
    }
}
