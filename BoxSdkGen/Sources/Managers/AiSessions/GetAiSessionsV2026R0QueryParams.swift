import Foundation

public class GetAiSessionsV2026R0QueryParams {
    /// Restricts the list to AI sessions with this origin. The only supported
    /// value is `api`.
    public let source: GetAiSessionsV2026R0QueryParamsSourceField

    /// The position marker at which to begin returning results, as returned in
    /// `next_marker` by the previous page. Omit it for the first page. All other
    /// parameters must match the request that returned the marker.
    public let marker: String?

    /// The field to sort results by. Possible values are `created_at`,
    /// `updated_at`, and `name`. Default is `updated_at`, which advances on each
    /// turn of session activity.
    public let sort: GetAiSessionsV2026R0QueryParamsSortField?

    /// The direction to sort results in, either ascending (`asc`) or
    /// descending (`desc`). Default is `desc`.
    public let direction: GetAiSessionsV2026R0QueryParamsDirectionField?

    /// The maximum number of AI sessions to return per page. The maximum is
    /// `100`; larger values are treated as `100`. The server may return fewer
    /// entries than requested.
    public let limit: Int?

    /// A comma-separated list of OAuth client IDs. Restricts the list to AI
    /// sessions created by any of these applications. Client IDs that match no
    /// application are ignored, so the response is an empty list if none of them
    /// match. Empty entries are ignored, and an empty value is treated as if the
    /// parameter were not provided.
    public let clientIds: [String]?

    /// Initializer for a GetAiSessionsV2026R0QueryParams.
    ///
    /// - Parameters:
    ///   - source: Restricts the list to AI sessions with this origin. The only supported
    ///     value is `api`.
    ///   - marker: The position marker at which to begin returning results, as returned in
    ///     `next_marker` by the previous page. Omit it for the first page. All other
    ///     parameters must match the request that returned the marker.
    ///   - sort: The field to sort results by. Possible values are `created_at`,
    ///     `updated_at`, and `name`. Default is `updated_at`, which advances on each
    ///     turn of session activity.
    ///   - direction: The direction to sort results in, either ascending (`asc`) or
    ///     descending (`desc`). Default is `desc`.
    ///   - limit: The maximum number of AI sessions to return per page. The maximum is
    ///     `100`; larger values are treated as `100`. The server may return fewer
    ///     entries than requested.
    ///   - clientIds: A comma-separated list of OAuth client IDs. Restricts the list to AI
    ///     sessions created by any of these applications. Client IDs that match no
    ///     application are ignored, so the response is an empty list if none of them
    ///     match. Empty entries are ignored, and an empty value is treated as if the
    ///     parameter were not provided.
    public init(source: GetAiSessionsV2026R0QueryParamsSourceField, marker: String? = nil, sort: GetAiSessionsV2026R0QueryParamsSortField? = nil, direction: GetAiSessionsV2026R0QueryParamsDirectionField? = nil, limit: Int? = nil, clientIds: [String]? = nil) {
        self.source = source
        self.marker = marker
        self.sort = sort
        self.direction = direction
        self.limit = limit
        self.clientIds = clientIds
    }

}
