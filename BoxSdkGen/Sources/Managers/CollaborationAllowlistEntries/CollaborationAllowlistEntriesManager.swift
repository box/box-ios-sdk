import Foundation

public class CollaborationAllowlistEntriesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns the list domains that have been deemed safe to create collaborations
    /// for within the current enterprise.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getCollaborationWhitelistEntries method
    ///   - headers: Headers of getCollaborationWhitelistEntries method
    /// - Returns: The `CollaborationAllowlistEntries`.
    /// - Throws: The `GeneralError`.
    public func getCollaborationWhitelistEntries(queryParams: GetCollaborationWhitelistEntriesQueryParams = GetCollaborationWhitelistEntriesQueryParams(), headers: GetCollaborationWhitelistEntriesHeaders = GetCollaborationWhitelistEntriesHeaders()) async throws -> CollaborationAllowlistEntries {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/collaboration_whitelist_entries")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try CollaborationAllowlistEntries.deserialize(from: response.data!)
    }

    /// Creates a new entry in the list of allowed domains to allow
    /// collaboration for.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createCollaborationWhitelistEntry method
    ///   - headers: Headers of createCollaborationWhitelistEntry method
    /// - Returns: The `CollaborationAllowlistEntry`.
    /// - Throws: The `GeneralError`.
    public func createCollaborationWhitelistEntry(requestBody: CreateCollaborationWhitelistEntryRequestBody, headers: CreateCollaborationWhitelistEntryHeaders = CreateCollaborationWhitelistEntryHeaders()) async throws -> CollaborationAllowlistEntry {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/collaboration_whitelist_entries")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try CollaborationAllowlistEntry.deserialize(from: response.data!)
    }

    /// Returns a domain that has been deemed safe to create collaborations
    /// for within the current enterprise.
    ///
    /// - Parameters:
    ///   - collaborationWhitelistEntryId: The ID of the entry in the list.
    ///     Example: "213123"
    ///   - headers: Headers of getCollaborationWhitelistEntryById method
    /// - Returns: The `CollaborationAllowlistEntry`.
    /// - Throws: The `GeneralError`.
    public func getCollaborationWhitelistEntryById(collaborationWhitelistEntryId: String, headers: GetCollaborationWhitelistEntryByIdHeaders = GetCollaborationWhitelistEntryByIdHeaders()) async throws -> CollaborationAllowlistEntry {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/collaboration_whitelist_entries/")\(collaborationWhitelistEntryId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try CollaborationAllowlistEntry.deserialize(from: response.data!)
    }

    /// Removes a domain from the list of domains that have been deemed safe to create
    /// collaborations for within the current enterprise.
    ///
    /// - Parameters:
    ///   - collaborationWhitelistEntryId: The ID of the entry in the list.
    ///     Example: "213123"
    ///   - headers: Headers of deleteCollaborationWhitelistEntryById method
    /// - Throws: The `GeneralError`.
    public func deleteCollaborationWhitelistEntryById(collaborationWhitelistEntryId: String, headers: DeleteCollaborationWhitelistEntryByIdHeaders = DeleteCollaborationWhitelistEntryByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/collaboration_whitelist_entries/")\(collaborationWhitelistEntryId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
