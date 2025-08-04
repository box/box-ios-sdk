import Foundation
import BoxSDKGen
import XCTest

class RecentItemsManagerTests: RetryableTestCase {

    public func testRecentItems() async throws {
        await runWithRetryAsync {
            let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
            let recentItems: RecentItems = try await client.recentItems.getRecentItems()
            XCTAssertTrue(recentItems.entries!.count >= 0)
        }
    }
}
