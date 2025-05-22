import Foundation

public class GetCollaborationsQueryParams {
    /// The status of the collaborations to retrieve
    public let status: GetCollaborationsQueryParamsStatusField

    /// A comma-separated list of attributes to include in the
    /// response. This can be used to request fields that are
    /// not normally returned in a standard response.
    /// 
    /// Be aware that specifying this parameter will have the
    /// effect that none of the standard fields are returned in
    /// the response unless explicitly specified, instead only
    /// fields for the mini representation are returned, additional
    /// to the fields requested.
    public let fields: [String]?

    /// The offset of the item at which to begin the response.
    /// 
    /// Queries with offset parameter value
    /// exceeding 10000 will be rejected
    /// with a 400 response.
    public let offset: Int64?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetCollaborationsQueryParams.
    ///
    /// - Parameters:
    ///   - status: The status of the collaborations to retrieve
    ///   - fields: A comma-separated list of attributes to include in the
    ///     response. This can be used to request fields that are
    ///     not normally returned in a standard response.
    ///     
    ///     Be aware that specifying this parameter will have the
    ///     effect that none of the standard fields are returned in
    ///     the response unless explicitly specified, instead only
    ///     fields for the mini representation are returned, additional
    ///     to the fields requested.
    ///   - offset: The offset of the item at which to begin the response.
    ///     
    ///     Queries with offset parameter value
    ///     exceeding 10000 will be rejected
    ///     with a 400 response.
    ///   - limit: The maximum number of items to return per page.
    public init(status: GetCollaborationsQueryParamsStatusField, fields: [String]? = nil, offset: Int64? = nil, limit: Int64? = nil) {
        self.status = status
        self.fields = fields
        self.offset = offset
        self.limit = limit
    }

}
