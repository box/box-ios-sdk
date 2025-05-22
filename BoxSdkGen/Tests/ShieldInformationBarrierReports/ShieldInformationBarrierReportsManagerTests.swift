import Foundation
import BoxSdkGen
import XCTest

class ShieldInformationBarrierReportsManagerTests: XCTestCase {

    public func testShieldInformationBarrierReports() async throws {
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
        let enterpriseId: String = Utils.getEnvironmentVariable(name: "ENTERPRISE_ID")
        let barrier: ShieldInformationBarrier = try await CommonsManager().getOrCreateShieldInformationBarrier(client: client, enterpriseId: enterpriseId)
        XCTAssertTrue(Utils.Strings.toString(value: barrier.status!) == "draft")
        XCTAssertTrue(Utils.Strings.toString(value: barrier.type!) == "shield_information_barrier")
        XCTAssertTrue(barrier.enterprise!.id == enterpriseId)
        XCTAssertTrue(Utils.Strings.toString(value: barrier.enterprise!.type) == "enterprise")
        let barrierId: String = barrier.id!
        let existingReports: ShieldInformationBarrierReports = try await client.shieldInformationBarrierReports.getShieldInformationBarrierReports(queryParams: GetShieldInformationBarrierReportsQueryParams(shieldInformationBarrierId: barrierId))
        if existingReports.entries!.count > 0 {
            return
        }

        let createdReport: ShieldInformationBarrierReport = try await client.shieldInformationBarrierReports.createShieldInformationBarrierReport(requestBody: ShieldInformationBarrierReference(shieldInformationBarrier: ShieldInformationBarrierBase(id: barrierId, type: ShieldInformationBarrierBaseTypeField.shieldInformationBarrier)))
        XCTAssertTrue(createdReport.shieldInformationBarrier!.shieldInformationBarrier!.id == barrierId)
        let retrievedReport: ShieldInformationBarrierReport = try await client.shieldInformationBarrierReports.getShieldInformationBarrierReportById(shieldInformationBarrierReportId: createdReport.id!)
        XCTAssertTrue(retrievedReport.id == createdReport.id)
        let retrievedReports: ShieldInformationBarrierReports = try await client.shieldInformationBarrierReports.getShieldInformationBarrierReports(queryParams: GetShieldInformationBarrierReportsQueryParams(shieldInformationBarrierId: barrierId))
        XCTAssertTrue(retrievedReports.entries!.count > 0)
    }
}
