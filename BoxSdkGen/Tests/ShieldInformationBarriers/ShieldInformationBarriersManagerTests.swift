import Foundation
import BoxSdkGen
import XCTest

class ShieldInformationBarriersManagerTests: XCTestCase {

    public func testShieldInformationBarriers() async throws {
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
        let enterpriseId: String = Utils.getEnvironmentVariable(name: "ENTERPRISE_ID")
        let barrier: ShieldInformationBarrier = try await CommonsManager().getOrCreateShieldInformationBarrier(client: client, enterpriseId: enterpriseId)
        XCTAssertTrue(Utils.Strings.toString(value: barrier.status!) == "draft")
        XCTAssertTrue(Utils.Strings.toString(value: barrier.type!) == "shield_information_barrier")
        XCTAssertTrue(barrier.enterprise!.id == enterpriseId)
        XCTAssertTrue(Utils.Strings.toString(value: barrier.enterprise!.type) == "enterprise")
        let barrierId: String = barrier.id!
        let barrierFromApi: ShieldInformationBarrier = try await client.shieldInformationBarriers.getShieldInformationBarrierById(shieldInformationBarrierId: barrierId)
        XCTAssertTrue(barrierFromApi.id! == barrierId)
        let barriers: ShieldInformationBarriers = try await client.shieldInformationBarriers.getShieldInformationBarriers()
        XCTAssertTrue(barriers.entries!.count == 1)
        await XCTAssertThrowsErrorAsync(try await client.shieldInformationBarriers.updateShieldInformationBarrierStatus(requestBody: UpdateShieldInformationBarrierStatusRequestBody(id: barrierId, status: UpdateShieldInformationBarrierStatusRequestBodyStatusField.disabled)))
    }
}
