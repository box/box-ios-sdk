import Foundation
import BoxSdkGen
import XCTest

class ArchivesManagerTests: RetryableTestCase {
    var userId: String!
    var client: BoxClient!

    override func setUp() async throws {
        userId = Utils.getEnvironmentVariable(name: "USER_ID")
        client = CommonsManager().getDefaultClientWithUserSubject(userId: userId)
    }

    public func testArchivesCreateListDelete() async throws {
        await runWithRetryAsync {
            let archiveName: String = Utils.getUUID()
            let archiveDescription: String = "Test Archive Description"
            let archive: ArchiveV2025R0 = try await client.archives.createArchiveV2025R0(requestBody: CreateArchiveV2025R0RequestBody(name: archiveName, description: archiveDescription))
            XCTAssertTrue(Utils.Strings.toString(value: archive.type) == "archive")
            XCTAssertTrue(archive.name == archiveName)
            XCTAssertTrue(archive.description == archiveDescription)
            let newArchiveName: String = Utils.getUUID()
            let newArchiveDescription: String = "Updated Archive Description"
            let updatedArchive: ArchiveV2025R0 = try await client.archives.updateArchiveByIdV2025R0(archiveId: archive.id, requestBody: UpdateArchiveByIdV2025R0RequestBody(name: newArchiveName, description: newArchiveDescription))
            XCTAssertTrue(updatedArchive.name == newArchiveName)
            XCTAssertTrue(updatedArchive.description! == newArchiveDescription)
            let archives: ArchivesV2025R0 = try await client.archives.getArchivesV2025R0(queryParams: GetArchivesV2025R0QueryParams(limit: Int64(100)))
            XCTAssertTrue(archives.entries!.count > 0)
            try await client.archives.deleteArchiveByIdV2025R0(archiveId: archive.id)
            await XCTAssertThrowsErrorAsync(try await client.archives.deleteArchiveByIdV2025R0(archiveId: archive.id))
        }
    }
}
