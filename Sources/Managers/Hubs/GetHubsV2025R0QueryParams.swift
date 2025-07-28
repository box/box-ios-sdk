import Foundation

public class GetHubsV2025R0QueryParams {
    /// The query string to search for hubs.
    public let query: String?

    /// The scope of the hubs to retrieve. Possible values include `editable`,
    /// `view_only`, and `all`. Default is `all`.
    public let scope: String?

    /// The field to sort results by. 
    /// Possible values include `name`, `updated_at`,
    /// `last_accessed_at`, `view_count`, and `relevance`.
    /// Default is `relevance`.
    public let sort: String?

    /// The direction to sort results in. This can be either in alphabetical ascending
    /// (`ASC`) or descending (`DESC`) order.
    public let direction: GetHubsV2025R0QueryParamsDirectionField?

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetHubsV2025R0QueryParams.
    ///
    /// - Parameters:
    ///   - query: The query string to search for hubs.
    ///   - scope: The scope of the hubs to retrieve. Possible values include `editable`,
    ///     `view_only`, and `all`. Default is `all`.
    ///   - sort: The field to sort results by. 
    ///     Possible values include `name`, `updated_at`,
    ///     `last_accessed_at`, `view_count`, and `relevance`.
    ///     Default is `relevance`.
    ///   - direction: The direction to sort results in. This can be either in alphabetical ascending
    ///     (`ASC`) or descending (`DESC`) order.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///   - limit: The maximum number of items to return per page.
    public init(query: String? = nil, scope: String? = nil, sort: String? = nil, direction: GetHubsV2025R0QueryParamsDirectionField? = nil, marker: String? = nil, limit: Int64? = nil) {
        self.query = query
        self.scope = scope
        self.sort = sort
        self.direction = direction
        self.marker = marker
        self.limit = limit
    }

}
