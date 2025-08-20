import Foundation

public class GetFileUploadSessionPartsByUrlQueryParams {
    /// The offset of the item at which to begin the response.
    /// 
    /// Queries with offset parameter value
    /// exceeding 10000 will be rejected
    /// with a 400 response.
    public let offset: Int64?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetFileUploadSessionPartsByUrlQueryParams.
    ///
    /// - Parameters:
    ///   - offset: The offset of the item at which to begin the response.
    ///     
    ///     Queries with offset parameter value
    ///     exceeding 10000 will be rejected
    ///     with a 400 response.
    ///   - limit: The maximum number of items to return per page.
    public init(offset: Int64? = nil, limit: Int64? = nil) {
        self.offset = offset
        self.limit = limit
    }

}
