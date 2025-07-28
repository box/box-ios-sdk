import Foundation

public class RecentItemsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns information about the recent items accessed
    /// by a user, either in the last 90 days or up to the last
    /// 1000 items accessed.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getRecentItems method
    ///   - headers: Headers of getRecentItems method
    /// - Returns: The `RecentItems`.
    /// - Throws: The `GeneralError`.
    public func getRecentItems(queryParams: GetRecentItemsQueryParams = GetRecentItemsQueryParams(), headers: GetRecentItemsHeaders = GetRecentItemsHeaders()) async throws -> RecentItems {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields), "limit": Utils.Strings.toString(value: queryParams.limit), "marker": Utils.Strings.toString(value: queryParams.marker)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/recent_items")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try RecentItems.deserialize(from: response.data!)
    }

}
