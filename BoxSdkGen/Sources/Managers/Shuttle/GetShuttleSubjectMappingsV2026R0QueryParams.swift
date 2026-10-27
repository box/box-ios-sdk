import Foundation

public class GetShuttleSubjectMappingsV2026R0QueryParams {
    /// The unique identifier of the shuttle job whose subject mappings to list.
    public let jobId: String

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetShuttleSubjectMappingsV2026R0QueryParams.
    ///
    /// - Parameters:
    ///   - jobId: The unique identifier of the shuttle job whose subject mappings to list.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    public init(jobId: String, marker: String? = nil, limit: Int64? = nil) {
        self.jobId = jobId
        self.marker = marker
        self.limit = limit
    }

}
