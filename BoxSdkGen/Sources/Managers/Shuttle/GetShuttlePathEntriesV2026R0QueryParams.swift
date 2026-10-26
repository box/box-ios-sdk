import Foundation

public class GetShuttlePathEntriesV2026R0QueryParams {
    /// The unique identifier of the shuttle job whose path entries to list.
    public let jobId: String

    /// The side of the migration to browse.
    public let side: GetShuttlePathEntriesV2026R0QueryParamsSideField

    /// The human-readable parent path whose children are returned. This can
    /// be used with or without `path_id`. Omit both, or pass `/` as `path`,
    /// to list root entries.
    public let path: String?

    /// The `path_id` value of the parent entry whose children are
    /// returned. This can be used with or without `path`. It distinguishes
    /// paths with identical names on systems that support stable identifiers.
    public let pathId: String?

    /// The email of the account whose path entries are returned. This is a
    /// system-native identifier and is not always an RFC 5322 address.
    public let accountEmail: String?

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetShuttlePathEntriesV2026R0QueryParams.
    ///
    /// - Parameters:
    ///   - jobId: The unique identifier of the shuttle job whose path entries to list.
    ///   - side: The side of the migration to browse.
    ///   - path: The human-readable parent path whose children are returned. This can
    ///     be used with or without `path_id`. Omit both, or pass `/` as `path`,
    ///     to list root entries.
    ///   - pathId: The `path_id` value of the parent entry whose children are
    ///     returned. This can be used with or without `path`. It distinguishes
    ///     paths with identical names on systems that support stable identifiers.
    ///   - accountEmail: The email of the account whose path entries are returned. This is a
    ///     system-native identifier and is not always an RFC 5322 address.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    public init(jobId: String, side: GetShuttlePathEntriesV2026R0QueryParamsSideField, path: String? = nil, pathId: String? = nil, accountEmail: String? = nil, marker: String? = nil, limit: Int64? = nil) {
        self.jobId = jobId
        self.side = side
        self.path = path
        self.pathId = pathId
        self.accountEmail = accountEmail
        self.marker = marker
        self.limit = limit
    }

}
