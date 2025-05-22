import Foundation

public class UserCollaborationsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves a single collaboration.
    ///
    /// - Parameters:
    ///   - collaborationId: The ID of the collaboration
    ///     Example: "1234"
    ///   - queryParams: Query parameters of getCollaborationById method
    ///   - headers: Headers of getCollaborationById method
    /// - Returns: The `Collaboration`.
    /// - Throws: The `GeneralError`.
    public func getCollaborationById(collaborationId: String, queryParams: GetCollaborationByIdQueryParams = GetCollaborationByIdQueryParams(), headers: GetCollaborationByIdHeaders = GetCollaborationByIdHeaders()) async throws -> Collaboration {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/collaborations/")\(collaborationId)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Collaboration.deserialize(from: response.data!)
    }

    /// Updates a collaboration.
    /// Can be used to change the owner of an item, or to
    /// accept collaboration invites.
    ///
    /// - Parameters:
    ///   - collaborationId: The ID of the collaboration
    ///     Example: "1234"
    ///   - requestBody: Request body of updateCollaborationById method
    ///   - headers: Headers of updateCollaborationById method
    /// - Returns: The `Collaboration?`.
    /// - Throws: The `GeneralError`.
    public func updateCollaborationById(collaborationId: String, requestBody: UpdateCollaborationByIdRequestBody, headers: UpdateCollaborationByIdHeaders = UpdateCollaborationByIdHeaders()) async throws -> Collaboration? {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/collaborations/")\(collaborationId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        if Utils.Strings.toString(value: response.status) == "204" {
            return nil
        }

        return try Collaboration?.deserialize(from: response.data!)
    }

    /// Deletes a single collaboration.
    ///
    /// - Parameters:
    ///   - collaborationId: The ID of the collaboration
    ///     Example: "1234"
    ///   - headers: Headers of deleteCollaborationById method
    /// - Throws: The `GeneralError`.
    public func deleteCollaborationById(collaborationId: String, headers: DeleteCollaborationByIdHeaders = DeleteCollaborationByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/collaborations/")\(collaborationId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Adds a collaboration for a single user or a single group to a file
    /// or folder.
    /// 
    /// Collaborations can be created using email address, user IDs, or a
    /// group IDs.
    /// 
    /// If a collaboration is being created with a group, access to
    /// this endpoint is dependent on the group's ability to be invited.
    /// 
    /// If collaboration is in `pending` status, the following fields
    /// are redacted:
    /// - `login` and `name` are hidden if a collaboration was created
    /// using `user_id`,
    /// -  `name` is hidden if a collaboration was created using `login`.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createCollaboration method
    ///   - queryParams: Query parameters of createCollaboration method
    ///   - headers: Headers of createCollaboration method
    /// - Returns: The `Collaboration`.
    /// - Throws: The `GeneralError`.
    public func createCollaboration(requestBody: CreateCollaborationRequestBody, queryParams: CreateCollaborationQueryParams = CreateCollaborationQueryParams(), headers: CreateCollaborationHeaders = CreateCollaborationHeaders()) async throws -> Collaboration {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields), "notify": Utils.Strings.toString(value: queryParams.notify)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/collaborations")", method: "POST", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Collaboration.deserialize(from: response.data!)
    }

}
