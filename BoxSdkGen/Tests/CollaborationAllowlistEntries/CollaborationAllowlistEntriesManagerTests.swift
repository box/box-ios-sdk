import Foundation
import BoxSdkGen
import XCTest

class CollaborationAllowlistEntriesManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testCollaborationAllowlistEntries() async throws {
        let allowlist: CollaborationAllowlistEntries = try await client.collaborationAllowlistEntries.getCollaborationWhitelistEntries()
        XCTAssertTrue(allowlist.entries!.count >= 0)
        let domain: String = "\(Utils.getUUID())\("example.com")"
        let newEntry: CollaborationAllowlistEntry = try await client.collaborationAllowlistEntries.createCollaborationWhitelistEntry(requestBody: CreateCollaborationWhitelistEntryRequestBody(domain: domain, direction: CreateCollaborationWhitelistEntryRequestBodyDirectionField.inbound))
        XCTAssertTrue(Utils.Strings.toString(value: newEntry.type) == "collaboration_whitelist_entry")
        XCTAssertTrue(Utils.Strings.toString(value: newEntry.direction) == "inbound")
        XCTAssertTrue(newEntry.domain == domain)
        let entry: CollaborationAllowlistEntry = try await client.collaborationAllowlistEntries.getCollaborationWhitelistEntryById(collaborationWhitelistEntryId: newEntry.id!)
        XCTAssertTrue(entry.id == newEntry.id)
        XCTAssertTrue(Utils.Strings.toString(value: entry.direction) == Utils.Strings.toString(value: newEntry.direction))
        XCTAssertTrue(entry.domain == domain)
        try await client.collaborationAllowlistEntries.deleteCollaborationWhitelistEntryById(collaborationWhitelistEntryId: entry.id!)
        await XCTAssertThrowsErrorAsync(try await client.collaborationAllowlistEntries.getCollaborationWhitelistEntryById(collaborationWhitelistEntryId: entry.id!))
    }
}
