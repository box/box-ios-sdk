import Foundation

public class GetRetentionPoliciesQueryParams {
    /// Filters results by a case sensitive prefix of the name of
    /// retention policies.
    public let policyName: String?

    /// Filters results by the type of retention policy.
    public let policyType: GetRetentionPoliciesQueryParamsPolicyTypeField?

    /// Filters results by the ID of the user who created policy.
    public let createdByUserId: String?

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

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    public let marker: String?

    /// Initializer for a GetRetentionPoliciesQueryParams.
    ///
    /// - Parameters:
    ///   - policyName: Filters results by a case sensitive prefix of the name of
    ///     retention policies.
    ///   - policyType: Filters results by the type of retention policy.
    ///   - createdByUserId: Filters results by the ID of the user who created policy.
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
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    public init(policyName: String? = nil, policyType: GetRetentionPoliciesQueryParamsPolicyTypeField? = nil, createdByUserId: String? = nil, fields: [String]? = nil, limit: Int64? = nil, marker: String? = nil) {
        self.policyName = policyName
        self.policyType = policyType
        self.createdByUserId = createdByUserId
        self.fields = fields
        self.limit = limit
        self.marker = marker
    }

}
