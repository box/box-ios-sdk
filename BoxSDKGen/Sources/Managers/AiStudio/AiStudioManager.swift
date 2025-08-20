import Foundation

public class AiStudioManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Lists AI agents based on the provided parameters.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getAiAgents method
    ///   - headers: Headers of getAiAgents method
    /// - Returns: The `AiMultipleAgentResponse`.
    /// - Throws: The `GeneralError`.
    public func getAiAgents(queryParams: GetAiAgentsQueryParams = GetAiAgentsQueryParams(), headers: GetAiAgentsHeaders = GetAiAgentsHeaders()) async throws -> AiMultipleAgentResponse {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["mode": Utils.Strings.toString(value: queryParams.mode), "fields": Utils.Strings.toString(value: queryParams.fields), "agent_state": Utils.Strings.toString(value: queryParams.agentState), "include_box_default": Utils.Strings.toString(value: queryParams.includeBoxDefault), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/ai_agents")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try AiMultipleAgentResponse.deserialize(from: response.data!)
    }

    /// Creates an AI agent. At least one of the following capabilities must be provided: `ask`, `text_gen`, `extract`.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createAiAgent method
    ///   - headers: Headers of createAiAgent method
    /// - Returns: The `AiSingleAgentResponseFull`.
    /// - Throws: The `GeneralError`.
    public func createAiAgent(requestBody: CreateAiAgent, headers: CreateAiAgentHeaders = CreateAiAgentHeaders()) async throws -> AiSingleAgentResponseFull {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/ai_agents")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try AiSingleAgentResponseFull.deserialize(from: response.data!)
    }

    /// Updates an AI agent.
    ///
    /// - Parameters:
    ///   - agentId: The ID of the agent to update.
    ///     Example: "1234"
    ///   - requestBody: Request body of updateAiAgentById method
    ///   - headers: Headers of updateAiAgentById method
    /// - Returns: The `AiSingleAgentResponseFull`.
    /// - Throws: The `GeneralError`.
    public func updateAiAgentById(agentId: String, requestBody: CreateAiAgent, headers: UpdateAiAgentByIdHeaders = UpdateAiAgentByIdHeaders()) async throws -> AiSingleAgentResponseFull {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/ai_agents/")\(agentId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try AiSingleAgentResponseFull.deserialize(from: response.data!)
    }

    /// Gets an AI Agent using the `agent_id` parameter.
    ///
    /// - Parameters:
    ///   - agentId: The agent id to get.
    ///     Example: "1234"
    ///   - queryParams: Query parameters of getAiAgentById method
    ///   - headers: Headers of getAiAgentById method
    /// - Returns: The `AiSingleAgentResponseFull`.
    /// - Throws: The `GeneralError`.
    public func getAiAgentById(agentId: String, queryParams: GetAiAgentByIdQueryParams = GetAiAgentByIdQueryParams(), headers: GetAiAgentByIdHeaders = GetAiAgentByIdHeaders()) async throws -> AiSingleAgentResponseFull {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/ai_agents/")\(agentId)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try AiSingleAgentResponseFull.deserialize(from: response.data!)
    }

    /// Deletes an AI agent using the provided parameters.
    ///
    /// - Parameters:
    ///   - agentId: The ID of the agent to delete.
    ///     Example: "1234"
    ///   - headers: Headers of deleteAiAgentById method
    /// - Throws: The `GeneralError`.
    public func deleteAiAgentById(agentId: String, headers: DeleteAiAgentByIdHeaders = DeleteAiAgentByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/ai_agents/")\(agentId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
