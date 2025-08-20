import Foundation

public class GetGroupsQueryParams {
    /// Limits the results to only groups whose `name` starts
    /// with the search term.
    public let filterTerm: String?

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

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// The offset of the item at which to begin the response.
    /// 
    /// Queries with offset parameter value
    /// exceeding 10000 will be rejected
    /// with a 400 response.
    public let offset: Int64?

    /// Initializer for a GetGroupsQueryParams.
    ///
    /// - Parameters:
    ///   - filterTerm: Limits the results to only groups whose `name` starts
    ///     with the search term.
    ///   - fields: A comma-separated list of attributes to include in the
    ///     response. This can be used to request fields that are
    ///     not normally returned in a standard response.
    ///     
    ///     Be aware that specifying this parameter will have the
    ///     effect that none of the standard fields are returned in
    ///     the response unless explicitly specified, instead only
    ///     fields for the mini representation are returned, additional
    ///     to the fields requested.
    ///   - limit: The maximum number of items to return per page.
    ///   - offset: The offset of the item at which to begin the response.
    ///     
    ///     Queries with offset parameter value
    ///     exceeding 10000 will be rejected
    ///     with a 400 response.
    public init(filterTerm: String? = nil, fields: [String]? = nil, limit: Int64? = nil, offset: Int64? = nil) {
        self.filterTerm = filterTerm
        self.fields = fields
        self.limit = limit
        self.offset = offset
    }

}
