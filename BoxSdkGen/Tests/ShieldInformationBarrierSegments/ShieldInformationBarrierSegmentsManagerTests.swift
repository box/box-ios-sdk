import Foundation
import BoxSdkGen
import XCTest

class ShieldInformationBarrierSegmentsManagerTests: XCTestCase {

    public func testShieldInformationBarrierSegments() async throws {
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
        let enterpriseId: String = Utils.getEnvironmentVariable(name: "ENTERPRISE_ID")
        let barrier: ShieldInformationBarrier = try await CommonsManager().getOrCreateShieldInformationBarrier(client: client, enterpriseId: enterpriseId)
        let barrierId: String = barrier.id!
        let segmentName: String = Utils.getUUID()
        let segmentDescription: String = "barrier segment description"
        let segment: ShieldInformationBarrierSegment = try await client.shieldInformationBarrierSegments.createShieldInformationBarrierSegment(requestBody: CreateShieldInformationBarrierSegmentRequestBody(shieldInformationBarrier: ShieldInformationBarrierBase(id: barrierId, type: ShieldInformationBarrierBaseTypeField.shieldInformationBarrier), name: segmentName, description: segmentDescription))
        XCTAssertTrue(segment.name! == segmentName)
        let segments: ShieldInformationBarrierSegments = try await client.shieldInformationBarrierSegments.getShieldInformationBarrierSegments(queryParams: GetShieldInformationBarrierSegmentsQueryParams(shieldInformationBarrierId: barrierId))
        XCTAssertTrue(segments.entries!.count > 0)
        let segmentId: String = segment.id!
        let segmentFromApi: ShieldInformationBarrierSegment = try await client.shieldInformationBarrierSegments.getShieldInformationBarrierSegmentById(shieldInformationBarrierSegmentId: segmentId)
        XCTAssertTrue(Utils.Strings.toString(value: segmentFromApi.type!) == "shield_information_barrier_segment")
        XCTAssertTrue(segmentFromApi.id! == segmentId)
        XCTAssertTrue(segmentFromApi.name! == segmentName)
        XCTAssertTrue(segmentFromApi.description! == segmentDescription)
        XCTAssertTrue(segmentFromApi.shieldInformationBarrier!.id == barrierId)
        let updatedSegmentDescription: String = "updated barrier segment description"
        let updatedSegment: ShieldInformationBarrierSegment = try await client.shieldInformationBarrierSegments.updateShieldInformationBarrierSegmentById(shieldInformationBarrierSegmentId: segmentId, requestBody: UpdateShieldInformationBarrierSegmentByIdRequestBody(description: .value(updatedSegmentDescription)))
        XCTAssertTrue(updatedSegment.description! == updatedSegmentDescription)
        try await client.shieldInformationBarrierSegments.deleteShieldInformationBarrierSegmentById(shieldInformationBarrierSegmentId: segmentId)
        await XCTAssertThrowsErrorAsync(try await client.shieldInformationBarrierSegments.getShieldInformationBarrierSegmentById(shieldInformationBarrierSegmentId: segmentId))
    }
}
