# WorkflowsManager


- [List workflows](#list-workflows)
- [Starts workflow based on request body](#starts-workflow-based-on-request-body)

## List workflows

Returns list of workflows that act on a given `folder ID`, and
have a flow with a trigger type of `WORKFLOW_MANUAL_START`.

You application must be authorized to use the `Manage Box Relay` application
scope within the developer console in to use this endpoint.

This operation is performed by calling function `getWorkflows`.

See the endpoint docs at
[API Reference](https://developer.box.com/reference/get-workflows/).

<!-- sample get_workflows -->
```
try await adminClient.workflows.getWorkflows(queryParams: GetWorkflowsQueryParams(folderId: workflowFolderId))
```

### Arguments

- queryParams `GetWorkflowsQueryParams`
  - Query parameters of getWorkflows method
- headers `GetWorkflowsHeaders`
  - Headers of getWorkflows method


### Returns

This function returns a value of type `Workflows`.

Returns the workflow.


## Starts workflow based on request body

Initiates a flow with a trigger type of `WORKFLOW_MANUAL_START`.

You application must be authorized to use the `Manage Box Relay` application
scope within the developer console.

This operation is performed by calling function `startWorkflow`.

See the endpoint docs at
[API Reference](https://developer.box.com/reference/post-workflows-id-start/).

<!-- sample post_workflows_id_start -->
```
try await adminClient.workflows.startWorkflow(workflowId: workflowToRun.id!, requestBody: StartWorkflowRequestBody(type: StartWorkflowRequestBodyTypeField.workflowParameters, flow: StartWorkflowRequestBodyFlowField(type: "flow", id: workflowToRun.flows![0].id!), files: [StartWorkflowRequestBodyFilesField(type: StartWorkflowRequestBodyFilesTypeField.file, id: workflowFileId)], folder: StartWorkflowRequestBodyFolderField(type: StartWorkflowRequestBodyFolderTypeField.folder, id: workflowFolderId)))
```

### Arguments

- workflowId `String`
  - The ID of the workflow. Example: "12345"
- requestBody `StartWorkflowRequestBody`
  - Request body of startWorkflow method
- headers `StartWorkflowHeaders`
  - Headers of startWorkflow method


### Returns

This function returns a value of type ``.

Starts the workflow.


