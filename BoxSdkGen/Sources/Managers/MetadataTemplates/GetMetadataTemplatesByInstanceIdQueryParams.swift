import Foundation

public class GetMetadataTemplatesByInstanceIdQueryParams {
    /// The ID of an instance of the metadata template to find.
    public let metadataInstanceId: String

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetMetadataTemplatesByInstanceIdQueryParams.
    ///
    /// - Parameters:
    ///   - metadataInstanceId: The ID of an instance of the metadata template to find.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    public init(metadataInstanceId: String, marker: String? = nil, limit: Int64? = nil) {
        self.metadataInstanceId = metadataInstanceId
        self.marker = marker
        self.limit = limit
    }

}
