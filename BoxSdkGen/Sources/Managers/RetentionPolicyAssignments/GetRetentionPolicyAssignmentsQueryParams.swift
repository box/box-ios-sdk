import Foundation

public class GetRetentionPolicyAssignmentsQueryParams {
    /// The type of the retention policy assignment to retrieve.
    public let type: GetRetentionPolicyAssignmentsQueryParamsTypeField?

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
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetRetentionPolicyAssignmentsQueryParams.
    ///
    /// - Parameters:
    ///   - type: The type of the retention policy assignment to retrieve.
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
    ///   - limit: The maximum number of items to return per page.
    public init(type: GetRetentionPolicyAssignmentsQueryParamsTypeField? = nil, fields: [String]? = nil, marker: String? = nil, limit: Int64? = nil) {
        self.type = type
        self.fields = fields
        self.marker = marker
        self.limit = limit
    }

}
