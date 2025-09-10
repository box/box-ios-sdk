import Foundation

public class WorkflowsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns list of workflows that act on a given `folder ID`, and
    /// have a flow with a trigger type of `WORKFLOW_MANUAL_START`.
    /// 
    /// You application must be authorized to use the `Manage Box Relay` application
    /// scope within the developer console in to use this endpoint.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getWorkflows method
    ///   - headers: Headers of getWorkflows method
    /// - Returns: The `Workflows`.
    /// - Throws: The `GeneralError`.
    public func getWorkflows(queryParams: GetWorkflowsQueryParams, headers: GetWorkflowsHeaders = GetWorkflowsHeaders()) async throws -> Workflows {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["folder_id": Utils.Strings.toString(value: queryParams.folderId), "trigger_type": Utils.Strings.toString(value: queryParams.triggerType), "limit": Utils.Strings.toString(value: queryParams.limit), "marker": Utils.Strings.toString(value: queryParams.marker)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/workflows")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Workflows.deserialize(from: response.data!)
    }

    /// Initiates a flow with a trigger type of `WORKFLOW_MANUAL_START`.
    /// 
    /// You application must be authorized to use the `Manage Box Relay` application
    /// scope within the developer console.
    ///
    /// - Parameters:
    ///   - workflowId: The ID of the workflow.
    ///     Example: "12345"
    ///   - requestBody: Request body of startWorkflow method
    ///   - headers: Headers of startWorkflow method
    /// - Throws: The `GeneralError`.
    public func startWorkflow(workflowId: String, requestBody: StartWorkflowRequestBody, headers: StartWorkflowHeaders = StartWorkflowHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/workflows/")\(workflowId)\("/start")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
