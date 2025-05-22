import Foundation
import BoxSdkGen
import XCTest

class MembershipsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testMemberships() async throws {
        let user: UserFull = try await client.users.createUser(requestBody: CreateUserRequestBody(name: Utils.getUUID(), login: "\(Utils.getUUID())\("@boxdemo.com")"))
        let userMemberships: GroupMemberships = try await client.memberships.getUserMemberships(userId: user.id)
        XCTAssertTrue(userMemberships.totalCount == 0)
        let group: GroupFull = try await client.groups.createGroup(requestBody: CreateGroupRequestBody(name: Utils.getUUID()))
        let groupMemberships: GroupMemberships = try await client.memberships.getGroupMemberships(groupId: group.id)
        XCTAssertTrue(groupMemberships.totalCount == 0)
        let groupMembership: GroupMembership = try await client.memberships.createGroupMembership(requestBody: CreateGroupMembershipRequestBody(user: CreateGroupMembershipRequestBodyUserField(id: user.id), group: CreateGroupMembershipRequestBodyGroupField(id: group.id)))
        XCTAssertTrue(groupMembership.user!.id == user.id)
        XCTAssertTrue(groupMembership.group!.id == group.id)
        XCTAssertTrue(Utils.Strings.toString(value: groupMembership.role) == "member")
        let getGroupMembership: GroupMembership = try await client.memberships.getGroupMembershipById(groupMembershipId: groupMembership.id!)
        XCTAssertTrue(getGroupMembership.id == groupMembership.id)
        let updatedGroupMembership: GroupMembership = try await client.memberships.updateGroupMembershipById(groupMembershipId: groupMembership.id!, requestBody: UpdateGroupMembershipByIdRequestBody(role: UpdateGroupMembershipByIdRequestBodyRoleField.admin))
        XCTAssertTrue(updatedGroupMembership.id == groupMembership.id)
        XCTAssertTrue(Utils.Strings.toString(value: updatedGroupMembership.role) == "admin")
        try await client.memberships.deleteGroupMembershipById(groupMembershipId: groupMembership.id!)
        await XCTAssertThrowsErrorAsync(try await client.memberships.getGroupMembershipById(groupMembershipId: groupMembership.id!))
        try await client.groups.deleteGroupById(groupId: group.id)
        try await client.users.deleteUserById(userId: user.id)
    }
}
