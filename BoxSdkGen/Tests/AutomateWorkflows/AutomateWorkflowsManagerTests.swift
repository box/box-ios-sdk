import Foundation
import BoxSdkGen
import XCTest

class AutomateWorkflowsManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testAutomateWorkflows() async throws {
        await runWithRetryAsync {
            let adminClient: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
            let workflowFolderId: String = Utils.getEnvironmentVariable(name: "AUTOMATE_WORKFLOW_FOLDER_ID")
            let uploadedFiles: Files = try await adminClient.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: Utils.getUUID(), parent: UploadFileRequestBodyAttributesParentField(id: workflowFolderId)), file: Utils.generateByteStream(size: 1024 * 1024)))
            let file: FileFull = uploadedFiles.entries![0]
            let workflowFileId: String = file.id
            let automateWorkflows: AutomateWorkflowsV2026R0 = try await adminClient.automateWorkflows.getAutomateWorkflowsV2026R0(queryParams: GetAutomateWorkflowsV2026R0QueryParams(folderId: workflowFolderId))
            XCTAssertTrue(automateWorkflows.entries!.count == 1)
            let workflowAction: AutomateWorkflowActionV2026R0 = automateWorkflows.entries![0]
            XCTAssertTrue(Utils.Strings.toString(value: workflowAction.type) == "workflow_action")
            XCTAssertTrue(Utils.Strings.toString(value: workflowAction.actionType) == "run_workflow")
            XCTAssertTrue(Utils.Strings.toString(value: workflowAction.workflow.type) == "workflow")
            try await adminClient.automateWorkflows.createAutomateWorkflowStartV2026R0(workflowId: workflowAction.workflow.id, requestBody: AutomateWorkflowStartRequestV2026R0(workflowActionId: workflowAction.id, fileIds: [workflowFileId]))
        }
    }
}
