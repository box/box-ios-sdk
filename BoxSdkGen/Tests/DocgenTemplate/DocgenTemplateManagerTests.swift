import Foundation
import BoxSdkGen
import XCTest

class DocgenTemplateManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testDocgenTemplateCrud() async throws {
        let file: FileFull = try await CommonsManager().uploadNewFile()
        let createdDocgenTemplate: DocGenTemplateBaseV2025R0 = try await client.docgenTemplate.createDocgenTemplateV2025R0(requestBody: DocGenTemplateCreateRequestV2025R0(file: FileReferenceV2025R0(id: file.id)))
        let docgenTemplates: DocGenTemplatesV2025R0 = try await client.docgenTemplate.getDocgenTemplatesV2025R0()
        XCTAssertTrue(docgenTemplates.entries!.count > 0)
        let fetchedDocgenTemplate: DocGenTemplateV2025R0 = try await client.docgenTemplate.getDocgenTemplateByIdV2025R0(templateId: createdDocgenTemplate.file!.id)
        XCTAssertTrue(fetchedDocgenTemplate.file!.id == createdDocgenTemplate.file!.id)
        let docgenTemplateTags: DocGenTagsV2025R0 = try await client.docgenTemplate.getDocgenTemplateTagsV2025R0(templateId: fetchedDocgenTemplate.file!.id)
        let docgenTemplateJobs: DocGenJobsV2025R0 = try await client.docgenTemplate.getDocgenTemplateJobByIdV2025R0(templateId: fetchedDocgenTemplate.file!.id)
        XCTAssertTrue(docgenTemplateJobs.entries!.count == 0)
        try await client.docgenTemplate.deleteDocgenTemplateByIdV2025R0(templateId: createdDocgenTemplate.file!.id)
        try await client.files.deleteFileById(fileId: file.id)
    }
}
