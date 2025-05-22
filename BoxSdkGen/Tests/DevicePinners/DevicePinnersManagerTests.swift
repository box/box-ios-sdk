import Foundation
import BoxSdkGen
import XCTest

class DevicePinnersManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testDevicePinners() async throws {
        let enterpriseId: String = Utils.getEnvironmentVariable(name: "ENTERPRISE_ID")
        let devicePinners: DevicePinners = try await client.devicePinners.getEnterpriseDevicePinners(enterpriseId: enterpriseId)
        XCTAssertTrue(devicePinners.entries!.count >= 0)
        let devicePinnersInDescDirection: DevicePinners = try await client.devicePinners.getEnterpriseDevicePinners(enterpriseId: enterpriseId, queryParams: GetEnterpriseDevicePinnersQueryParams(direction: GetEnterpriseDevicePinnersQueryParamsDirectionField.desc))
        XCTAssertTrue(devicePinnersInDescDirection.entries!.count >= 0)
        let devicePinnerId: String = "123456"
        await XCTAssertThrowsErrorAsync(try await client.devicePinners.getDevicePinnerById(devicePinnerId: devicePinnerId))
        await XCTAssertThrowsErrorAsync(try await client.devicePinners.deleteDevicePinnerById(devicePinnerId: devicePinnerId))
    }
}
