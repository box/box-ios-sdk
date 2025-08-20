import Foundation

public class GetEnterpriseMetadataTemplatesQueryParams {
    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetEnterpriseMetadataTemplatesQueryParams.
    ///
    /// - Parameters:
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    public init(marker: String? = nil, limit: Int64? = nil) {
        self.marker = marker
        self.limit = limit
    }

}
