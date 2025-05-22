import Foundation
import BoxSdkGen
import XCTest

class DocgenManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testDocgenBatchAndJobs() async throws {
        let uploadedFile: FileFull = try await CommonsManager().uploadNewFile()
        let folder: FolderFull = try await CommonsManager().createNewFolder()
        let createdDocgenTemplate: DocGenTemplateBaseV2025R0 = try await client.docgenTemplate.createDocgenTemplateV2025R0(requestBody: DocGenTemplateCreateRequestV2025R0(file: FileReferenceV2025R0(id: uploadedFile.id)))
        let docgenBatch: DocGenBatchBaseV2025R0 = try await client.docgen.createDocgenBatchV2025R0(requestBody: DocGenBatchCreateRequestV2025R0(file: FileReferenceV2025R0(id: uploadedFile.id), inputSource: "api", destinationFolder: DocGenBatchCreateRequestV2025R0DestinationFolderField(id: folder.id), outputType: "pdf", documentGenerationData: [DocGenDocumentGenerationDataV2025R0(generatedFileName: "test", userInput: ["abc": "xyz"])]))
        XCTAssertTrue(docgenBatch.id != "")
        XCTAssertTrue(Utils.Strings.toString(value: docgenBatch.type) == "docgen_batch")
        let docgenBatchJobs: DocGenJobsV2025R0 = try await client.docgen.getDocgenBatchJobByIdV2025R0(batchId: docgenBatch.id)
        XCTAssertTrue(docgenBatchJobs.entries!.count >= 1)
        XCTAssertTrue(docgenBatchJobs.entries![0].id != "")
        XCTAssertTrue(Utils.Strings.toString(value: docgenBatchJobs.entries![0].type) == "docgen_job")
        XCTAssertTrue(docgenBatchJobs.entries![0].outputType == "pdf")
        XCTAssertTrue(Utils.Strings.toString(value: docgenBatchJobs.entries![0].status) != "")
        XCTAssertTrue(docgenBatchJobs.entries![0].templateFile.id == uploadedFile.id)
        XCTAssertTrue(docgenBatchJobs.entries![0].batch.id == docgenBatch.id)
        let docgenJobs: DocGenJobsFullV2025R0 = try await client.docgen.getDocgenJobsV2025R0()
        XCTAssertTrue(docgenJobs.entries!.count >= 1)
        XCTAssertTrue(docgenJobs.entries![0].batch.id != "")
        XCTAssertTrue(docgenJobs.entries![0].createdBy.id != "")
        XCTAssertTrue(docgenJobs.entries![0].enterprise.id != "")
        XCTAssertTrue(docgenJobs.entries![0].id != "")
        XCTAssertTrue(docgenJobs.entries![0].outputType != "")
        XCTAssertTrue(docgenJobs.entries![0].source != "")
        XCTAssertTrue(Utils.Strings.toString(value: docgenJobs.entries![0].status) != "")
        XCTAssertTrue(Utils.Strings.toString(value: docgenJobs.entries![0].templateFile.type) == "file")
        XCTAssertTrue(docgenJobs.entries![0].templateFile.id != "")
        XCTAssertTrue(Utils.Strings.toString(value: docgenJobs.entries![0].templateFileVersion.type) == "file_version")
        XCTAssertTrue(docgenJobs.entries![0].templateFileVersion.id != "")
        XCTAssertTrue(Utils.Strings.toString(value: docgenJobs.entries![0].type) == "docgen_job")
        let docgenJob: DocGenJobV2025R0 = try await client.docgen.getDocgenJobByIdV2025R0(jobId: docgenJobs.entries![0].id)
        XCTAssertTrue(docgenJob.batch.id != "")
        XCTAssertTrue(docgenJob.id != "")
        XCTAssertTrue(docgenJob.outputType != "")
        XCTAssertTrue(Utils.Strings.toString(value: docgenJob.status) != "")
        XCTAssertTrue(Utils.Strings.toString(value: docgenJob.templateFile.type) == "file")
        XCTAssertTrue(docgenJob.templateFile.id != "")
        XCTAssertTrue(Utils.Strings.toString(value: docgenJob.templateFileVersion.type) == "file_version")
        XCTAssertTrue(docgenJob.templateFileVersion.id != "")
        XCTAssertTrue(Utils.Strings.toString(value: docgenJob.type) == "docgen_job")
        try await client.folders.deleteFolderById(folderId: folder.id)
        try await client.files.deleteFileById(fileId: uploadedFile.id)
    }
}
