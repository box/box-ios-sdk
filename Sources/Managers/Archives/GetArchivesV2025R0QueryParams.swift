import Foundation

public class GetArchivesV2025R0QueryParams {
    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    public let marker: String?

    /// Initializer for a GetArchivesV2025R0QueryParams.
    ///
    /// - Parameters:
    ///   - limit: The maximum number of items to return per page.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    public init(limit: Int64? = nil, marker: String? = nil) {
        self.limit = limit
        self.marker = marker
    }

}
