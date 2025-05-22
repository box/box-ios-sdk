import Foundation
import BoxSdkGen
import XCTest

class StoragePoliciesManagerTests: XCTestCase {
    var userId: String!

    override func setUp() async throws {
        userId = Utils.getEnvironmentVariable(name: "USER_ID")
    }

    public func testGetStoragePolicies() async throws {
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: userId)
        let storagePolicies: StoragePolicies = try await client.storagePolicies.getStoragePolicies()
        let storagePolicy: StoragePolicy = storagePolicies.entries![0]
        XCTAssertTrue(Utils.Strings.toString(value: storagePolicy.type) == "storage_policy")
        let getStoragePolicy: StoragePolicy = try await client.storagePolicies.getStoragePolicyById(storagePolicyId: storagePolicy.id)
        XCTAssertTrue(getStoragePolicy.id == storagePolicy.id)
    }
}
