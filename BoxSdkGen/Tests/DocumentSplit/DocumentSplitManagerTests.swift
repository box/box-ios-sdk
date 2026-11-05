import Foundation
import BoxSdkGen
import XCTest

class DocumentSplitManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testGetDocumentSplitsV2026R0() async throws {
        await runWithRetryAsync {
            let documentSplits: DocumentSplitsV2026R0 = try await client.documentSplit.getDocumentSplitsV2026R0(queryParams: GetDocumentSplitsV2026R0QueryParams(limit: Int64(10)))
            XCTAssertTrue(documentSplits.entries!.count >= 0)
        }
    }
}
