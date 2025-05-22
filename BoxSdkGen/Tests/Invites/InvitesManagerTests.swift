import Foundation
import BoxSdkGen
import XCTest

class InvitesManagerTests: XCTestCase {

    public func testInvites() async throws {
        let userId: String = Utils.getEnvironmentVariable(name: "USER_ID")
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: userId)
        let currentUser: UserFull = try await client.users.getUserMe(queryParams: GetUserMeQueryParams(fields: ["enterprise"]))
        let email: String = Utils.getEnvironmentVariable(name: "BOX_EXTERNAL_USER_EMAIL")
        let invitation: Invite = try await client.invites.createInvite(requestBody: CreateInviteRequestBody(enterprise: CreateInviteRequestBodyEnterpriseField(id: currentUser.enterprise!.id!), actionableBy: CreateInviteRequestBodyActionableByField(login: email)))
        XCTAssertTrue(Utils.Strings.toString(value: invitation.type) == "invite")
        XCTAssertTrue(invitation.invitedTo!.id == currentUser.enterprise!.id)
        XCTAssertTrue(invitation.actionableBy!.login == email)
        let getInvitation: Invite = try await client.invites.getInviteById(inviteId: invitation.id)
        XCTAssertTrue(getInvitation.id == invitation.id)
    }
}
