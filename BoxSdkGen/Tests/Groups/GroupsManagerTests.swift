import Foundation
import BoxSdkGen
import XCTest

class GroupsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testGetGroups() async throws {
        let groups: Groups = try await client.groups.getGroups()
        XCTAssertTrue(groups.totalCount! >= 0)
    }

    public func testCreateGetDeleteGroup() async throws {
        let groupName: String = Utils.getUUID()
        let groupDescription: String = "Group description"
        let group: GroupFull = try await client.groups.createGroup(requestBody: CreateGroupRequestBody(name: groupName, description: groupDescription))
        XCTAssertTrue(group.name == groupName)
        let groupById: GroupFull = try await client.groups.getGroupById(groupId: group.id, queryParams: GetGroupByIdQueryParams(fields: ["id", "name", "description", "group_type"]))
        XCTAssertTrue(groupById.id == group.id)
        XCTAssertTrue(groupById.description == groupDescription)
        let updatedGroupName: String = Utils.getUUID()
        let updatedGroup: GroupFull = try await client.groups.updateGroupById(groupId: group.id, requestBody: UpdateGroupByIdRequestBody(name: updatedGroupName))
        XCTAssertTrue(updatedGroup.name == updatedGroupName)
        try await client.groups.deleteGroupById(groupId: group.id)
        await XCTAssertThrowsErrorAsync(try await client.groups.getGroupById(groupId: group.id))
    }
}
