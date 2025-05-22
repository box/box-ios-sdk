import Foundation
import BoxSdkGen
import XCTest

class TrashedItemsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testListTrashedItems() async throws {
        let file: FileFull = try await CommonsManager().uploadNewFile()
        try await client.files.deleteFileById(fileId: file.id)
        let trashedItems: Items = try await client.trashedItems.getTrashedItems()
        XCTAssertTrue(trashedItems.entries!.count > 0)
    }
}
