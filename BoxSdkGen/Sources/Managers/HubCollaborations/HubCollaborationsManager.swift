import Foundation

public class HubCollaborationsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves all collaborations for a Box Hub.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getHubCollaborationsV2025R0 method
    ///   - headers: Headers of getHubCollaborationsV2025R0 method
    /// - Returns: The `HubCollaborationsV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getHubCollaborationsV2025R0(queryParams: GetHubCollaborationsV2025R0QueryParams, headers: GetHubCollaborationsV2025R0Headers = GetHubCollaborationsV2025R0Headers()) async throws -> HubCollaborationsV2025R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["hub_id": Utils.Strings.toString(value: queryParams.hubId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hub_collaborations")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubCollaborationsV2025R0.deserialize(from: response.data!)
    }

    /// Adds a collaboration for a single user or a single group to a Box Hub.
    /// 
    /// Collaborations can be created using email address, user IDs, or group IDs.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createHubCollaborationV2025R0 method
    ///   - headers: Headers of createHubCollaborationV2025R0 method
    /// - Returns: The `HubCollaborationV2025R0`.
    /// - Throws: The `GeneralError`.
    public func createHubCollaborationV2025R0(requestBody: HubCollaborationCreateRequestV2025R0, headers: CreateHubCollaborationV2025R0Headers = CreateHubCollaborationV2025R0Headers()) async throws -> HubCollaborationV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hub_collaborations")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubCollaborationV2025R0.deserialize(from: response.data!)
    }

    /// Retrieves details for a Box Hub collaboration by collaboration ID.
    ///
    /// - Parameters:
    ///   - hubCollaborationId: The ID of the hub collaboration.
    ///     Example: "1234"
    ///   - headers: Headers of getHubCollaborationByIdV2025R0 method
    /// - Returns: The `HubCollaborationV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getHubCollaborationByIdV2025R0(hubCollaborationId: String, headers: GetHubCollaborationByIdV2025R0Headers = GetHubCollaborationByIdV2025R0Headers()) async throws -> HubCollaborationV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hub_collaborations/")\(hubCollaborationId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubCollaborationV2025R0.deserialize(from: response.data!)
    }

    /// Updates a Box Hub collaboration.
    /// Can be used to change the Box Hub role.
    ///
    /// - Parameters:
    ///   - hubCollaborationId: The ID of the hub collaboration.
    ///     Example: "1234"
    ///   - requestBody: Request body of updateHubCollaborationByIdV2025R0 method
    ///   - headers: Headers of updateHubCollaborationByIdV2025R0 method
    /// - Returns: The `HubCollaborationV2025R0`.
    /// - Throws: The `GeneralError`.
    public func updateHubCollaborationByIdV2025R0(hubCollaborationId: String, requestBody: HubCollaborationUpdateRequestV2025R0, headers: UpdateHubCollaborationByIdV2025R0Headers = UpdateHubCollaborationByIdV2025R0Headers()) async throws -> HubCollaborationV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hub_collaborations/")\(hubCollaborationId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubCollaborationV2025R0.deserialize(from: response.data!)
    }

    /// Deletes a single Box Hub collaboration.
    ///
    /// - Parameters:
    ///   - hubCollaborationId: The ID of the hub collaboration.
    ///     Example: "1234"
    ///   - headers: Headers of deleteHubCollaborationByIdV2025R0 method
    /// - Throws: The `GeneralError`.
    public func deleteHubCollaborationByIdV2025R0(hubCollaborationId: String, headers: DeleteHubCollaborationByIdV2025R0Headers = DeleteHubCollaborationByIdV2025R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hub_collaborations/")\(hubCollaborationId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
