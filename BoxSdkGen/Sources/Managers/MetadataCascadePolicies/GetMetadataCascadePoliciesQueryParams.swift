import Foundation

public class GetMetadataCascadePoliciesQueryParams {
    /// Specifies which folder to return policies for. This can not be used on the
    /// root folder with ID `0`.
    public let folderId: String

    /// The ID of the enterprise ID for which to find metadata
    /// cascade policies. If not specified, it defaults to the
    /// current enterprise.
    public let ownerEnterpriseId: String?

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The offset of the item at which to begin the response.
    /// 
    /// Queries with offset parameter value
    /// exceeding 10000 will be rejected
    /// with a 400 response.
    public let offset: Int64?

    /// Initializer for a GetMetadataCascadePoliciesQueryParams.
    ///
    /// - Parameters:
    ///   - folderId: Specifies which folder to return policies for. This can not be used on the
    ///     root folder with ID `0`.
    ///   - ownerEnterpriseId: The ID of the enterprise ID for which to find metadata
    ///     cascade policies. If not specified, it defaults to the
    ///     current enterprise.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - offset: The offset of the item at which to begin the response.
    ///     
    ///     Queries with offset parameter value
    ///     exceeding 10000 will be rejected
    ///     with a 400 response.
    public init(folderId: String, ownerEnterpriseId: String? = nil, marker: String? = nil, offset: Int64? = nil) {
        self.folderId = folderId
        self.ownerEnterpriseId = ownerEnterpriseId
        self.marker = marker
        self.offset = offset
    }

}
