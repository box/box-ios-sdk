import Foundation
import BoxSdkGen
import XCTest

class NotesManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
    }

    public func testConvertMarkdownToBoxNote() async throws {
        await runWithRetryAsync {
            let noteName: String = Utils.getUUID()
            let markdownContent: String = "# Heading\n\nSome text"
            let response: NotesConvertResponseV2026R0 = try await client.notes.createNoteConvertV2026R0(requestBody: NotesConvertRequestBodyV2026R0(content: markdownContent, parent: FolderReferenceV2026R0(id: "0"), name: noteName, contentFormat: NotesConvertRequestBodyV2026R0ContentFormatField.markdown))
            XCTAssertTrue(response.id != "")
            XCTAssertTrue(Utils.Strings.toString(value: response.type) == "file")
            let file: FileFull = try await client.files.getFileById(fileId: response.id)
            XCTAssertTrue(file.name == "\(noteName)\(".boxnote")")
            XCTAssertTrue(file.parent!.id == "0")
            try await client.files.deleteFileById(fileId: response.id)
        }
    }
}
