import Foundation

public class GetShuttleReportsV2026R0QueryParams {
    /// The unique identifier of the shuttle run whose reports to list.
    public let runId: String

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetShuttleReportsV2026R0QueryParams.
    ///
    /// - Parameters:
    ///   - runId: The unique identifier of the shuttle run whose reports to list.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    public init(runId: String, marker: String? = nil, limit: Int64? = nil) {
        self.runId = runId
        self.marker = marker
        self.limit = limit
    }

}
