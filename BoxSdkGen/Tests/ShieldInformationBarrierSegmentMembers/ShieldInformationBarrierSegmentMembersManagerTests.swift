import Foundation
import BoxSdkGen
import XCTest

class ShieldInformationBarrierSegmentMembersManagerTests: XCTestCase {

    public func testShieldInformationBarrierSegmentMembers() async throws {
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
        let enterpriseId: String = Utils.getEnvironmentVariable(name: "ENTERPRISE_ID")
        let barrier: ShieldInformationBarrier = try await CommonsManager().getOrCreateShieldInformationBarrier(client: client, enterpriseId: enterpriseId)
        let barrierId: String = barrier.id!
        let segmentName: String = Utils.getUUID()
        let segment: ShieldInformationBarrierSegment = try await client.shieldInformationBarrierSegments.createShieldInformationBarrierSegment(requestBody: CreateShieldInformationBarrierSegmentRequestBody(shieldInformationBarrier: ShieldInformationBarrierBase(id: barrierId, type: ShieldInformationBarrierBaseTypeField.shieldInformationBarrier), name: segmentName))
        XCTAssertTrue(segment.name! == segmentName)
        let segmentMember: ShieldInformationBarrierSegmentMember = try await client.shieldInformationBarrierSegmentMembers.createShieldInformationBarrierSegmentMember(requestBody: CreateShieldInformationBarrierSegmentMemberRequestBody(shieldInformationBarrierSegment: CreateShieldInformationBarrierSegmentMemberRequestBodyShieldInformationBarrierSegmentField(id: segment.id!, type: CreateShieldInformationBarrierSegmentMemberRequestBodyShieldInformationBarrierSegmentTypeField.shieldInformationBarrierSegment), user: UserBase(id: Utils.getEnvironmentVariable(name: "USER_ID"))))
        XCTAssertTrue(segmentMember.user!.id == Utils.getEnvironmentVariable(name: "USER_ID"))
        XCTAssertTrue(segmentMember.shieldInformationBarrierSegment!.id == segment.id!)
        let segmentMembers: ShieldInformationBarrierSegmentMembers = try await client.shieldInformationBarrierSegmentMembers.getShieldInformationBarrierSegmentMembers(queryParams: GetShieldInformationBarrierSegmentMembersQueryParams(shieldInformationBarrierSegmentId: segment.id!))
        XCTAssertTrue(segmentMembers.entries!.count > 0)
        let segmentMemberGet: ShieldInformationBarrierSegmentMember = try await client.shieldInformationBarrierSegmentMembers.getShieldInformationBarrierSegmentMemberById(shieldInformationBarrierSegmentMemberId: segmentMember.id!)
        XCTAssertTrue(segmentMemberGet.id! == segmentMember.id!)
        try await client.shieldInformationBarrierSegmentMembers.deleteShieldInformationBarrierSegmentMemberById(shieldInformationBarrierSegmentMemberId: segmentMember.id!)
        await XCTAssertThrowsErrorAsync(try await client.shieldInformationBarrierSegmentMembers.getShieldInformationBarrierSegmentMemberById(shieldInformationBarrierSegmentMemberId: segmentMember.id!))
        try await client.shieldInformationBarrierSegments.deleteShieldInformationBarrierSegmentById(shieldInformationBarrierSegmentId: segment.id!)
    }
}
