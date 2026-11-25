import Foundation
import BoxSdkGen
import XCTest

class AiSessionsManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testAiSessionsWithNonExistentIdV2026R0() async throws {
        await runWithRetryAsync {
            let aiSessionId: String = "123456"
            let aiSessions: AiSessionsV2026R0 = try await client.aiSessions.getAiSessionsV2026R0(queryParams: GetAiSessionsV2026R0QueryParams(source: GetAiSessionsV2026R0QueryParamsSourceField.api))
            XCTAssertTrue(aiSessions.entries.count >= 0)
            await XCTAssertThrowsErrorAsync(try await client.aiSessions.deleteAiSessionByIdV2026R0(aiSessionId: aiSessionId))
        }
    }
}
