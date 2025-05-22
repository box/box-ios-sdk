import Foundation
import BoxSdkGen
import XCTest

class WorkflowsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testWorkflows() async throws {
        let adminClient: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
        let workflowFolderId: String = Utils.getEnvironmentVariable(name: "WORKFLOW_FOLDER_ID")
        let uploadedFiles: Files = try await adminClient.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: Utils.getUUID(), parent: UploadFileRequestBodyAttributesParentField(id: workflowFolderId)), file: Utils.generateByteStream(size: 1024 * 1024)))
        let file: FileFull = uploadedFiles.entries![0]
        let workflowFileId: String = file.id
        let workflows: Workflows = try await adminClient.workflows.getWorkflows(queryParams: GetWorkflowsQueryParams(folderId: workflowFolderId))
        XCTAssertTrue(workflows.entries!.count == 1)
        let workflowToRun: Workflow = workflows.entries![0]
        XCTAssertTrue(Utils.Strings.toString(value: workflowToRun.type!) == "workflow")
        XCTAssertTrue(workflowToRun.isEnabled! == true)
        XCTAssertTrue(Utils.Strings.toString(value: workflowToRun.flows![0].type!) == "flow")
        XCTAssertTrue(Utils.Strings.toString(value: workflowToRun.flows![0].trigger!.type!) == "trigger")
        XCTAssertTrue(Utils.Strings.toString(value: workflowToRun.flows![0].trigger!.triggerType!) == "WORKFLOW_MANUAL_START")
        XCTAssertTrue(Utils.Strings.toString(value: workflowToRun.flows![0].outcomes![0].actionType!) == "delete_file")
        XCTAssertTrue(Utils.Strings.toString(value: workflowToRun.flows![0].outcomes![0].type!) == "outcome")
        try await adminClient.workflows.startWorkflow(workflowId: workflowToRun.id!, requestBody: StartWorkflowRequestBody(flow: StartWorkflowRequestBodyFlowField(type: "flow", id: workflowToRun.flows![0].id!), files: [StartWorkflowRequestBodyFilesField(type: StartWorkflowRequestBodyFilesTypeField.file, id: workflowFileId)], folder: StartWorkflowRequestBodyFolderField(type: StartWorkflowRequestBodyFolderTypeField.folder, id: workflowFolderId), type: StartWorkflowRequestBodyTypeField.workflowParameters))
    }
}
