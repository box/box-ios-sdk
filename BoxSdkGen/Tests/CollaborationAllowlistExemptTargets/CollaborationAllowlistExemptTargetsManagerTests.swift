import Foundation
import BoxSdkGen
import XCTest

class CollaborationAllowlistExemptTargetsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testCollaborationAllowlistExemptTargets() async throws {
        let exemptTargets: CollaborationAllowlistExemptTargets = try await client.collaborationAllowlistExemptTargets.getCollaborationWhitelistExemptTargets()
        XCTAssertTrue(exemptTargets.entries!.count >= 0)
        let user: UserFull = try await client.users.createUser(requestBody: CreateUserRequestBody(name: Utils.getUUID(), login: "\(Utils.getUUID())\("@boxdemo.com")", isPlatformAccessOnly: true))
        let newExemptTarget: CollaborationAllowlistExemptTarget = try await client.collaborationAllowlistExemptTargets.createCollaborationWhitelistExemptTarget(requestBody: CreateCollaborationWhitelistExemptTargetRequestBody(user: CreateCollaborationWhitelistExemptTargetRequestBodyUserField(id: user.id)))
        XCTAssertTrue(Utils.Strings.toString(value: newExemptTarget.type) == "collaboration_whitelist_exempt_target")
        XCTAssertTrue(newExemptTarget.user!.id == user.id)
        let exemptTarget: CollaborationAllowlistExemptTarget = try await client.collaborationAllowlistExemptTargets.getCollaborationWhitelistExemptTargetById(collaborationWhitelistExemptTargetId: newExemptTarget.id!)
        XCTAssertTrue(exemptTarget.id == newExemptTarget.id)
        XCTAssertTrue(exemptTarget.user!.id == user.id)
        try await client.collaborationAllowlistExemptTargets.deleteCollaborationWhitelistExemptTargetById(collaborationWhitelistExemptTargetId: exemptTarget.id!)
        await XCTAssertThrowsErrorAsync(try await client.collaborationAllowlistExemptTargets.getCollaborationWhitelistExemptTargetById(collaborationWhitelistExemptTargetId: exemptTarget.id!))
        try await client.users.deleteUserById(userId: user.id)
    }
}
