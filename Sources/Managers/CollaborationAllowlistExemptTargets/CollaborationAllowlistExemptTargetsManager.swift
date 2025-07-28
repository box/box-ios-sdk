import Foundation

public class CollaborationAllowlistExemptTargetsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns a list of users who have been exempt from the collaboration
    /// domain restrictions.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getCollaborationWhitelistExemptTargets method
    ///   - headers: Headers of getCollaborationWhitelistExemptTargets method
    /// - Returns: The `CollaborationAllowlistExemptTargets`.
    /// - Throws: The `GeneralError`.
    public func getCollaborationWhitelistExemptTargets(queryParams: GetCollaborationWhitelistExemptTargetsQueryParams = GetCollaborationWhitelistExemptTargetsQueryParams(), headers: GetCollaborationWhitelistExemptTargetsHeaders = GetCollaborationWhitelistExemptTargetsHeaders()) async throws -> CollaborationAllowlistExemptTargets {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/collaboration_whitelist_exempt_targets")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try CollaborationAllowlistExemptTargets.deserialize(from: response.data!)
    }

    /// Exempts a user from the restrictions set out by the allowed list of domains
    /// for collaborations.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createCollaborationWhitelistExemptTarget method
    ///   - headers: Headers of createCollaborationWhitelistExemptTarget method
    /// - Returns: The `CollaborationAllowlistExemptTarget`.
    /// - Throws: The `GeneralError`.
    public func createCollaborationWhitelistExemptTarget(requestBody: CreateCollaborationWhitelistExemptTargetRequestBody, headers: CreateCollaborationWhitelistExemptTargetHeaders = CreateCollaborationWhitelistExemptTargetHeaders()) async throws -> CollaborationAllowlistExemptTarget {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/collaboration_whitelist_exempt_targets")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try CollaborationAllowlistExemptTarget.deserialize(from: response.data!)
    }

    /// Returns a users who has been exempt from the collaboration
    /// domain restrictions.
    ///
    /// - Parameters:
    ///   - collaborationWhitelistExemptTargetId: The ID of the exemption to the list.
    ///     Example: "984923"
    ///   - headers: Headers of getCollaborationWhitelistExemptTargetById method
    /// - Returns: The `CollaborationAllowlistExemptTarget`.
    /// - Throws: The `GeneralError`.
    public func getCollaborationWhitelistExemptTargetById(collaborationWhitelistExemptTargetId: String, headers: GetCollaborationWhitelistExemptTargetByIdHeaders = GetCollaborationWhitelistExemptTargetByIdHeaders()) async throws -> CollaborationAllowlistExemptTarget {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/collaboration_whitelist_exempt_targets/")\(collaborationWhitelistExemptTargetId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try CollaborationAllowlistExemptTarget.deserialize(from: response.data!)
    }

    /// Removes a user's exemption from the restrictions set out by the allowed list
    /// of domains for collaborations.
    ///
    /// - Parameters:
    ///   - collaborationWhitelistExemptTargetId: The ID of the exemption to the list.
    ///     Example: "984923"
    ///   - headers: Headers of deleteCollaborationWhitelistExemptTargetById method
    /// - Throws: The `GeneralError`.
    public func deleteCollaborationWhitelistExemptTargetById(collaborationWhitelistExemptTargetId: String, headers: DeleteCollaborationWhitelistExemptTargetByIdHeaders = DeleteCollaborationWhitelistExemptTargetByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/collaboration_whitelist_exempt_targets/")\(collaborationWhitelistExemptTargetId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
