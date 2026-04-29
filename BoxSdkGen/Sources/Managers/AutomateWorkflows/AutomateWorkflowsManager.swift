import Foundation

public class AutomateWorkflowsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns workflow actions from Automate for a folder, using the
    /// `WORKFLOW` action category.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getAutomateWorkflowsV2026R0 method
    ///   - headers: Headers of getAutomateWorkflowsV2026R0 method
    /// - Returns: The `AutomateWorkflowsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getAutomateWorkflowsV2026R0(queryParams: GetAutomateWorkflowsV2026R0QueryParams, headers: GetAutomateWorkflowsV2026R0Headers = GetAutomateWorkflowsV2026R0Headers()) async throws -> AutomateWorkflowsV2026R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["folder_id": Utils.Strings.toString(value: queryParams.folderId), "limit": Utils.Strings.toString(value: queryParams.limit), "marker": Utils.Strings.toString(value: queryParams.marker)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/automate_workflows")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try AutomateWorkflowsV2026R0.deserialize(from: response.data!)
    }

    /// Starts an Automate workflow manually by using a workflow action ID and file IDs.
    ///
    /// - Parameters:
    ///   - workflowId: The ID of the workflow.
    ///     Example: "12345"
    ///   - requestBody: Request body of createAutomateWorkflowStartV2026R0 method
    ///   - headers: Headers of createAutomateWorkflowStartV2026R0 method
    /// - Throws: The `GeneralError`.
    public func createAutomateWorkflowStartV2026R0(workflowId: String, requestBody: AutomateWorkflowStartRequestV2026R0, headers: CreateAutomateWorkflowStartV2026R0Headers = CreateAutomateWorkflowStartV2026R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/automate_workflows/")\(Utils.Strings.toString(value: workflowId)!)\("/start")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
