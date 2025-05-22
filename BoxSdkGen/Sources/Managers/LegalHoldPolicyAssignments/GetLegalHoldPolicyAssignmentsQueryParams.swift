import Foundation

public class GetLegalHoldPolicyAssignmentsQueryParams {
    /// The ID of the legal hold policy
    public let policyId: String

    /// Filters the results by the type of item the
    /// policy was applied to.
    public let assignToType: GetLegalHoldPolicyAssignmentsQueryParamsAssignToTypeField?

    /// Filters the results by the ID of item the
    /// policy was applied to.
    public let assignToId: String?

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

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

    /// Initializer for a GetLegalHoldPolicyAssignmentsQueryParams.
    ///
    /// - Parameters:
    ///   - policyId: The ID of the legal hold policy
    ///   - assignToType: Filters the results by the type of item the
    ///     policy was applied to.
    ///   - assignToId: Filters the results by the ID of item the
    ///     policy was applied to.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    ///   - limit: The maximum number of items to return per page.
    ///   - fields: A comma-separated list of attributes to include in the
    ///     response. This can be used to request fields that are
    ///     not normally returned in a standard response.
    ///     
    ///     Be aware that specifying this parameter will have the
    ///     effect that none of the standard fields are returned in
    ///     the response unless explicitly specified, instead only
    ///     fields for the mini representation are returned, additional
    ///     to the fields requested.
    public init(policyId: String, assignToType: GetLegalHoldPolicyAssignmentsQueryParamsAssignToTypeField? = nil, assignToId: String? = nil, marker: String? = nil, limit: Int64? = nil, fields: [String]? = nil) {
        self.policyId = policyId
        self.assignToType = assignToType
        self.assignToId = assignToId
        self.marker = marker
        self.limit = limit
        self.fields = fields
    }

}
