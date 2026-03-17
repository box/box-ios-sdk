import Foundation

public class HubDocumentManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves a list of Hub Document Pages for the specified hub.
    /// Includes both root-level pages and sub pages.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getHubDocumentPagesV2025R0 method
    ///   - headers: Headers of getHubDocumentPagesV2025R0 method
    /// - Returns: The `HubDocumentPagesV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getHubDocumentPagesV2025R0(queryParams: GetHubDocumentPagesV2025R0QueryParams, headers: GetHubDocumentPagesV2025R0Headers = GetHubDocumentPagesV2025R0Headers()) async throws -> HubDocumentPagesV2025R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["hub_id": Utils.Strings.toString(value: queryParams.hubId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hub_document_pages")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubDocumentPagesV2025R0.deserialize(from: response.data!)
    }

    /// Retrieves a sorted list of all Hub Document Blocks on a specified page in the hub document, excluding items.
    /// Blocks are hierarchically organized by their `parent_id`.
    /// Blocks are sorted in order based on user specification in the user interface.
    /// The response will only include content blocks that belong to the specified page. This will not include sub pages or sub page content blocks.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getHubDocumentBlocksV2025R0 method
    ///   - headers: Headers of getHubDocumentBlocksV2025R0 method
    /// - Returns: The `HubDocumentBlocksV2025R0`.
    /// - Throws: The `GeneralError`.
    public func getHubDocumentBlocksV2025R0(queryParams: GetHubDocumentBlocksV2025R0QueryParams, headers: GetHubDocumentBlocksV2025R0Headers = GetHubDocumentBlocksV2025R0Headers()) async throws -> HubDocumentBlocksV2025R0 {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["hub_id": Utils.Strings.toString(value: queryParams.hubId), "page_id": Utils.Strings.toString(value: queryParams.pageId), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/hub_document_blocks")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try HubDocumentBlocksV2025R0.deserialize(from: response.data!)
    }

}
