import Foundation

public class AiSessionsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns a marker-paginated list of the AI sessions that the authenticated
    /// user can read and that were created through the Box public API. Entries are
    /// ordered by `sort` and `direction`, defaulting to `updated_at` descending so
    /// the most recently active session appears first.
    /// 
    /// The access token must have both the `ai.readwrite` and `root_readwrite`
    /// scopes.
    /// 
    /// A page may contain fewer than `limit` entries while further pages remain.
    /// Treat a non-null `next_marker` as the only signal that more results exist.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getAiSessionsV2026R0 method
    ///   - headers: Headers of getAiSessionsV2026R0 method
    /// - Returns: The `AiSessionsV2026R0`.
    /// - Throws: The `GeneralError`.
    public func getAiSessionsV2026R0(queryParams: GetAiSessionsV2026R0QueryParams, headers: GetAiSessionsV2026R0Headers = GetAiSessionsV2026R0Headers()) async throws -> AiSessionsV2026R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["source": Utils.Strings.toString(value: queryParams.source), "marker": Utils.Strings.toString(value: queryParams.marker), "sort": Utils.Strings.toString(value: queryParams.sort), "direction": Utils.Strings.toString(value: queryParams.direction), "limit": Utils.Strings.toString(value: queryParams.limit), "client_ids": Utils.Strings.toString(value: queryParams.clientIds)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/ai_sessions")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try AiSessionsV2026R0.deserialize(from: response.data!)
    }

    /// Deletes an AI session created through the Box public API, together with its
    /// agent tasks. The session's agent-generated files and uploaded files are
    /// moved to the trash. Files attached as sources from elsewhere in Box are not
    /// affected. Deleting a session does not stop a running task or notify the
    /// agent.
    /// 
    /// The access token must have both the `ai.readwrite` and `root_readwrite`
    /// scopes.
    ///
    /// - Parameters:
    ///   - aiSessionId: The unique identifier of the AI session. This is the same value returned as
    ///     `id` by the list endpoint and used as the A2A `contextId`.
    ///     Example: "23489723"
    ///   - headers: Headers of deleteAiSessionByIdV2026R0 method
    /// - Throws: The `GeneralError`.
    public func deleteAiSessionByIdV2026R0(aiSessionId: String, headers: DeleteAiSessionByIdV2026R0Headers = DeleteAiSessionByIdV2026R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/ai_sessions/")\(Utils.Strings.toString(value: aiSessionId)!)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
