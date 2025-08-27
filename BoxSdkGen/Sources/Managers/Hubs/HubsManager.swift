import Foundation

public class HubsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves all hubs for requesting user.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getHubsV2025R0 method
    ///   - headers: Headers of getHubsV2025R0 method
    /// - Returns: The `HubsV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getHubsV2025R0(queryParams: GetHubsV2025R0QueryParams = GetHubsV2025R0QueryParams(), headers: GetHubsV2025R0Headers = GetHubsV2025R0Headers()) async throws -> HubsV2025R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["query": Utils.Strings.toString(value: queryParams.query), "scope": Utils.Strings.toString(value: queryParams.scope), "sort": Utils.Strings.toString(value: queryParams.sort), "direction": Utils.Strings.toString(value: queryParams.direction), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hubs")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubsV2025R0.deserialize(from: response.data!)
    }

    /// Creates a new Hub.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createHubV2025R0 method
    ///   - headers: Headers of createHubV2025R0 method
    /// - Returns: The `HubV2025R0`.
    /// - Throws: The `GeneralError`.
    public func createHubV2025R0(requestBody: HubCreateRequestV2025R0, headers: CreateHubV2025R0Headers = CreateHubV2025R0Headers()) async throws -> HubV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hubs")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubV2025R0.deserialize(from: response.data!)
    }

    /// Retrieves all hubs for a given enterprise.
    /// 
    /// Admins or Hub Co-admins of an enterprise
    /// with GCM scope can make this call.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getEnterpriseHubsV2025R0 method
    ///   - headers: Headers of getEnterpriseHubsV2025R0 method
    /// - Returns: The `HubsV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getEnterpriseHubsV2025R0(queryParams: GetEnterpriseHubsV2025R0QueryParams = GetEnterpriseHubsV2025R0QueryParams(), headers: GetEnterpriseHubsV2025R0Headers = GetEnterpriseHubsV2025R0Headers()) async throws -> HubsV2025R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["query": Utils.Strings.toString(value: queryParams.query), "sort": Utils.Strings.toString(value: queryParams.sort), "direction": Utils.Strings.toString(value: queryParams.direction), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/enterprise_hubs")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubsV2025R0.deserialize(from: response.data!)
    }

    /// Retrieves details for a hub by its ID.
    ///
    /// - Parameters:
    ///   - hubId: The unique identifier that represent a hub.
    ///     
    ///     The ID for any hub can be determined
    ///     by visiting this hub in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/hubs/123`
    ///     the `hub_id` is `123`.
    ///     Example: "12345"
    ///   - headers: Headers of getHubByIdV2025R0 method
    /// - Returns: The `HubV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getHubByIdV2025R0(hubId: String, headers: GetHubByIdV2025R0Headers = GetHubByIdV2025R0Headers()) async throws -> HubV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hubs/")\(hubId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubV2025R0.deserialize(from: response.data!)
    }

    /// Updates a Hub. Can be used to change title, description, or Hub settings.
    ///
    /// - Parameters:
    ///   - hubId: The unique identifier that represent a hub.
    ///     
    ///     The ID for any hub can be determined
    ///     by visiting this hub in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/hubs/123`
    ///     the `hub_id` is `123`.
    ///     Example: "12345"
    ///   - requestBody: Request body of updateHubByIdV2025R0 method
    ///   - headers: Headers of updateHubByIdV2025R0 method
    /// - Returns: The `HubV2025R0`.
    /// - Throws: The `GeneralError`.
    public func updateHubByIdV2025R0(hubId: String, requestBody: HubUpdateRequestV2025R0, headers: UpdateHubByIdV2025R0Headers = UpdateHubByIdV2025R0Headers()) async throws -> HubV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hubs/")\(hubId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubV2025R0.deserialize(from: response.data!)
    }

    /// Deletes a single hub.
    ///
    /// - Parameters:
    ///   - hubId: The unique identifier that represent a hub.
    ///     
    ///     The ID for any hub can be determined
    ///     by visiting this hub in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/hubs/123`
    ///     the `hub_id` is `123`.
    ///     Example: "12345"
    ///   - headers: Headers of deleteHubByIdV2025R0 method
    /// - Throws: The `GeneralError`.
    public func deleteHubByIdV2025R0(hubId: String, headers: DeleteHubByIdV2025R0Headers = DeleteHubByIdV2025R0Headers()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hubs/")\(hubId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Creates a copy of a Hub.
    /// 
    /// The original Hub will not be modified.
    ///
    /// - Parameters:
    ///   - hubId: The unique identifier that represent a hub.
    ///     
    ///     The ID for any hub can be determined
    ///     by visiting this hub in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/hubs/123`
    ///     the `hub_id` is `123`.
    ///     Example: "12345"
    ///   - requestBody: Request body of copyHubV2025R0 method
    ///   - headers: Headers of copyHubV2025R0 method
    /// - Returns: The `HubV2025R0`.
    /// - Throws: The `GeneralError`.
    public func copyHubV2025R0(hubId: String, requestBody: HubCopyRequestV2025R0, headers: CopyHubV2025R0Headers = CopyHubV2025R0Headers()) async throws -> HubV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hubs/")\(hubId)\("/copy")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubV2025R0.deserialize(from: response.data!)
    }

}
