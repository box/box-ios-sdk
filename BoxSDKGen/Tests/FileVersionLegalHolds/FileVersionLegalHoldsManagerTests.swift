import Foundation
import BoxSDKGen
import XCTest

class FileVersionLegalHoldsManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testGetFileVersionLegalHolds() async throws {
        await runWithRetryAsync {
            let policyId: String = "1234567890"
            let fileVersionLegalHolds: FileVersionLegalHolds = try await client.fileVersionLegalHolds.getFileVersionLegalHolds(queryParams: GetFileVersionLegalHoldsQueryParams(policyId: policyId))
            let fileVersionLegalHoldsCount: Int = fileVersionLegalHolds.entries!.count
            XCTAssertTrue(fileVersionLegalHoldsCount >= 0)
        }
    }

    public func testGetFileVersionLegalHoldById() async throws {
        await runWithRetryAsync {
            let fileVersionLegalHoldId: String = "987654321"
            await XCTAssertThrowsErrorAsync(try await client.fileVersionLegalHolds.getFileVersionLegalHoldById(fileVersionLegalHoldId: fileVersionLegalHoldId))
        }
    }
}
