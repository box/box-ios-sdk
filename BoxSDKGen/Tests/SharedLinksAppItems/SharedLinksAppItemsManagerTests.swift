import Foundation
import BoxSDKGen
import XCTest

class SharedLinksAppItemsManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testSharedLinksAppItems() async throws {
        await runWithRetryAsync {
            let appItemSharedLink: String = Utils.getEnvironmentVariable(name: "APP_ITEM_SHARED_LINK")
            let appItem: AppItem = try await client.sharedLinksAppItems.findAppItemForSharedLink(headers: FindAppItemForSharedLinkHeaders(boxapi: "\("shared_link=")\(appItemSharedLink)"))
            XCTAssertTrue(Utils.Strings.toString(value: appItem.type) == "app_item")
            XCTAssertTrue(appItem.applicationType == "hubs")
        }
    }
}
