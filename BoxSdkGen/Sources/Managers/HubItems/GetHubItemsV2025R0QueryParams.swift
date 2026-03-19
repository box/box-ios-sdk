import Foundation

public class GetHubItemsV2025R0QueryParams {
    /// The unique identifier that represent a hub.
    /// 
    /// The ID for any hub can be determined
    /// by visiting this hub in the web application
    /// and copying the ID from the URL. For example,
    /// for the URL `https://*.app.box.com/hubs/123`
    /// the `hub_id` is `123`.
    public let hubId: String

    /// The unique identifier of an item list block within the Box Hub.
    /// 
    /// When provided, the response will only include items that belong
    /// to the specified item list, allowing you to filter results to
    /// items on a specific page or section.
    public let parentId: String?

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetHubItemsV2025R0QueryParams.
    ///
    /// - Parameters:
    ///   - hubId: The unique identifier that represent a hub.
    ///     
    ///     The ID for any hub can be determined
    ///     by visiting this hub in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/hubs/123`
    ///     the `hub_id` is `123`.
    ///   - parentId: The unique identifier of an item list block within the Box Hub.
    ///     
    ///     When provided, the response will only include items that belong
    ///     to the specified item list, allowing you to filter results to
    ///     items on a specific page or section.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    public init(hubId: String, parentId: String? = nil, marker: String? = nil, limit: Int64? = nil) {
        self.hubId = hubId
        self.parentId = parentId
        self.marker = marker
        self.limit = limit
    }

}
