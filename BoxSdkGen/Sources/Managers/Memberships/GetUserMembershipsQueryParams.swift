import Foundation

public class GetUserMembershipsQueryParams {
    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// The offset of the item at which to begin the response.
    /// 
    /// Queries with offset parameter value
    /// exceeding 10000 will be rejected
    /// with a 400 response.
    public let offset: Int64?

    /// Initializer for a GetUserMembershipsQueryParams.
    ///
    /// - Parameters:
    ///   - limit: The maximum number of items to return per page.
    ///   - offset: The offset of the item at which to begin the response.
    ///     
    ///     Queries with offset parameter value
    ///     exceeding 10000 will be rejected
    ///     with a 400 response.
    public init(limit: Int64? = nil, offset: Int64? = nil) {
        self.limit = limit
        self.offset = offset
    }

}
