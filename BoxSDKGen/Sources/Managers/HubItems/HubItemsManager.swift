import Foundation

public class HubItemsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves all items associated with a Hub.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getHubItemsV2025R0 method
    ///   - headers: Headers of getHubItemsV2025R0 method
    /// - Returns: The `HubItemsV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getHubItemsV2025R0(queryParams: GetHubItemsV2025R0QueryParams, headers: GetHubItemsV2025R0Headers = GetHubItemsV2025R0Headers()) async throws -> HubItemsV2025R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["hub_id": Utils.Strings.toString(value: queryParams.hubId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hub_items")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubItemsV2025R0.deserialize(from: response.data!)
    }

    /// Adds and/or removes Hub items from a Hub.
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
    ///   - requestBody: Request body of manageHubItemsV2025R0 method
    ///   - headers: Headers of manageHubItemsV2025R0 method
    /// - Returns: The `HubItemsManageResponseV2025R0`.
    /// - Throws: The `GeneralError`.
    public func manageHubItemsV2025R0(hubId: String, requestBody: HubItemsManageRequestV2025R0, headers: ManageHubItemsV2025R0Headers = ManageHubItemsV2025R0Headers()) async throws -> HubItemsManageResponseV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hubs/")\(hubId)\("/manage_items")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubItemsManageResponseV2025R0.deserialize(from: response.data!)
    }

}
