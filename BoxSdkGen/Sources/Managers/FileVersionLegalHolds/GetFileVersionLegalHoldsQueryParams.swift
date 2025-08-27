import Foundation

public class GetFileVersionLegalHoldsQueryParams {
    /// The ID of the legal hold policy to get the file version legal
    /// holds for.
    public let policyId: String

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetFileVersionLegalHoldsQueryParams.
    ///
    /// - Parameters:
    ///   - policyId: The ID of the legal hold policy to get the file version legal
    ///     holds for.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    public init(policyId: String, marker: String? = nil, limit: Int64? = nil) {
        self.policyId = policyId
        self.marker = marker
        self.limit = limit
    }

}
