import Foundation
import BoxSdkGen
import XCTest

class ShieldInformationBarrierSegmentRestrictionsManagerTests: XCTestCase {

    public func testShieldInformationBarrierSegmentRestrictions() async throws {
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
        let enterpriseId: String = Utils.getEnvironmentVariable(name: "ENTERPRISE_ID")
        let barrier: ShieldInformationBarrier = try await CommonsManager().getOrCreateShieldInformationBarrier(client: client, enterpriseId: enterpriseId)
        let barrierId: String = barrier.id!
        let segment: ShieldInformationBarrierSegment = try await client.shieldInformationBarrierSegments.createShieldInformationBarrierSegment(requestBody: CreateShieldInformationBarrierSegmentRequestBody(shieldInformationBarrier: ShieldInformationBarrierBase(id: barrierId, type: ShieldInformationBarrierBaseTypeField.shieldInformationBarrier), name: Utils.getUUID(), description: "barrier segment description"))
        let segmentId: String = segment.id!
        let segmentToRestrict: ShieldInformationBarrierSegment = try await client.shieldInformationBarrierSegments.createShieldInformationBarrierSegment(requestBody: CreateShieldInformationBarrierSegmentRequestBody(shieldInformationBarrier: ShieldInformationBarrierBase(id: barrierId, type: ShieldInformationBarrierBaseTypeField.shieldInformationBarrier), name: Utils.getUUID(), description: "barrier segment description"))
        let segmentToRestrictId: String = segmentToRestrict.id!
        let segmentRestriction: ShieldInformationBarrierSegmentRestriction = try await client.shieldInformationBarrierSegmentRestrictions.createShieldInformationBarrierSegmentRestriction(requestBody: CreateShieldInformationBarrierSegmentRestrictionRequestBody(shieldInformationBarrierSegment: CreateShieldInformationBarrierSegmentRestrictionRequestBodyShieldInformationBarrierSegmentField(id: segmentId, type: CreateShieldInformationBarrierSegmentRestrictionRequestBodyShieldInformationBarrierSegmentTypeField.shieldInformationBarrierSegment), restrictedSegment: CreateShieldInformationBarrierSegmentRestrictionRequestBodyRestrictedSegmentField(id: segmentToRestrictId, type: CreateShieldInformationBarrierSegmentRestrictionRequestBodyRestrictedSegmentTypeField.shieldInformationBarrierSegment), type: CreateShieldInformationBarrierSegmentRestrictionRequestBodyTypeField.shieldInformationBarrierSegmentRestriction))
        let segmentRestrictionId: String = segmentRestriction.id!
        XCTAssertTrue(segmentRestriction.shieldInformationBarrierSegment.id == segmentId)
        let segmentRestrictions: ShieldInformationBarrierSegmentRestrictions = try await client.shieldInformationBarrierSegmentRestrictions.getShieldInformationBarrierSegmentRestrictions(queryParams: GetShieldInformationBarrierSegmentRestrictionsQueryParams(shieldInformationBarrierSegmentId: segmentId))
        XCTAssertTrue(segmentRestrictions.entries!.count > 0)
        let segmentRestrictionFromApi: ShieldInformationBarrierSegmentRestriction = try await client.shieldInformationBarrierSegmentRestrictions.getShieldInformationBarrierSegmentRestrictionById(shieldInformationBarrierSegmentRestrictionId: segmentRestrictionId)
        XCTAssertTrue(segmentRestrictionFromApi.id! == segmentRestrictionId)
        XCTAssertTrue(segmentRestrictionFromApi.shieldInformationBarrierSegment.id == segmentId)
        XCTAssertTrue(segmentRestrictionFromApi.restrictedSegment.id == segmentToRestrictId)
        XCTAssertTrue(segmentRestrictionFromApi.shieldInformationBarrier!.id == barrierId)
        try await client.shieldInformationBarrierSegmentRestrictions.deleteShieldInformationBarrierSegmentRestrictionById(shieldInformationBarrierSegmentRestrictionId: segmentRestrictionId)
        await XCTAssertThrowsErrorAsync(try await client.shieldInformationBarrierSegmentRestrictions.getShieldInformationBarrierSegmentRestrictionById(shieldInformationBarrierSegmentRestrictionId: segmentRestrictionId))
        try await client.shieldInformationBarrierSegments.deleteShieldInformationBarrierSegmentById(shieldInformationBarrierSegmentId: segmentId)
        try await client.shieldInformationBarrierSegments.deleteShieldInformationBarrierSegmentById(shieldInformationBarrierSegmentId: segmentToRestrictId)
    }
}
