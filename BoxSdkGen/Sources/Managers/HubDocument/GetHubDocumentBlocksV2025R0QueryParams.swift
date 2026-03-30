import Foundation

public class GetHubDocumentBlocksV2025R0QueryParams {
    /// The unique identifier that represent a hub.
    /// 
    /// The ID for any hub can be determined
    /// by visiting this hub in the web application
    /// and copying the ID from the URL. For example,
    /// for the URL `https://*.app.box.com/hubs/123`
    /// the `hub_id` is `123`.
    public let hubId: String

    /// The unique identifier of a page within the Box Hub.
    public let pageId: String

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetHubDocumentBlocksV2025R0QueryParams.
    ///
    /// - Parameters:
    ///   - hubId: The unique identifier that represent a hub.
    ///     
    ///     The ID for any hub can be determined
    ///     by visiting this hub in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/hubs/123`
    ///     the `hub_id` is `123`.
    ///   - pageId: The unique identifier of a page within the Box Hub.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///   - limit: The maximum number of items to return per page.
    public init(hubId: String, pageId: String, marker: String? = nil, limit: Int64? = nil) {
        self.hubId = hubId
        self.pageId = pageId
        self.marker = marker
        self.limit = limit
    }

}
