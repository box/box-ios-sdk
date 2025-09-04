import Foundation

public class GetEnterpriseHubsV2025R0QueryParams {
    /// The query string to search for Box Hubs.
    public let query: String?

    /// The field to sort results by.
    /// Possible values include `name`, `updated_at`,
    /// `last_accessed_at`, `view_count`, and `relevance`.
    /// Default is `relevance`.
    public let sort: String?

    /// The direction to sort results in. This can be either in alphabetical ascending
    /// (`ASC`) or descending (`DESC`) order.
    public let direction: GetEnterpriseHubsV2025R0QueryParamsDirectionField?

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetEnterpriseHubsV2025R0QueryParams.
    ///
    /// - Parameters:
    ///   - query: The query string to search for Box Hubs.
    ///   - sort: The field to sort results by.
    ///     Possible values include `name`, `updated_at`,
    ///     `last_accessed_at`, `view_count`, and `relevance`.
    ///     Default is `relevance`.
    ///   - direction: The direction to sort results in. This can be either in alphabetical ascending
    ///     (`ASC`) or descending (`DESC`) order.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///   - limit: The maximum number of items to return per page.
    public init(query: String? = nil, sort: String? = nil, direction: GetEnterpriseHubsV2025R0QueryParamsDirectionField? = nil, marker: String? = nil, limit: Int64? = nil) {
        self.query = query
        self.sort = sort
        self.direction = direction
        self.marker = marker
        self.limit = limit
    }

}
