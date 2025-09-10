import Foundation

public class GetLegalHoldPoliciesQueryParams {
    /// Limits results to policies for which the names start with
    /// this search term. This is a case-insensitive prefix.
    public let policyName: String?

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

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetLegalHoldPoliciesQueryParams.
    ///
    /// - Parameters:
    ///   - policyName: Limits results to policies for which the names start with
    ///     this search term. This is a case-insensitive prefix.
    ///   - fields: A comma-separated list of attributes to include in the
    ///     response. This can be used to request fields that are
    ///     not normally returned in a standard response.
    ///     
    ///     Be aware that specifying this parameter will have the
    ///     effect that none of the standard fields are returned in
    ///     the response unless explicitly specified, instead only
    ///     fields for the mini representation are returned, additional
    ///     to the fields requested.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    public init(policyName: String? = nil, fields: [String]? = nil, marker: String? = nil, limit: Int64? = nil) {
        self.policyName = policyName
        self.fields = fields
        self.marker = marker
        self.limit = limit
    }

}
