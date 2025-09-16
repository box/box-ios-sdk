import Foundation

public class GetUsersQueryParams {
    /// Limits the results to only users who's `name` or
    /// `login` start with the search term.
    /// 
    /// For externally managed users, the search term needs
    /// to completely match the in order to find the user, and
    /// it will only return one user at a time.
    public let filterTerm: String?

    /// Limits the results to the kind of user specified.
    /// 
    /// * `all` returns every kind of user for whom the
    ///   `login` or `name` partially matches the
    ///   `filter_term`. It will only return an external user
    ///   if the login matches the `filter_term` completely,
    ///   and in that case it will only return that user.
    /// * `managed` returns all managed and app users for whom
    ///   the `login` or `name` partially matches the
    ///   `filter_term`.
    /// * `external` returns all external users for whom the
    ///   `login` matches the `filter_term` exactly.
    public let userType: GetUsersQueryParamsUserTypeField?

    /// Limits the results to app users with the given
    /// `external_app_user_id` value.
    /// 
    /// When creating an app user, an
    /// `external_app_user_id` value can be set. This value can
    /// then be used in this endpoint to find any users that
    /// match that `external_app_user_id` value.
    public let externalAppUserId: String?

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

    /// Specifies whether to use marker-based pagination instead of
    /// offset-based pagination. Only one pagination method can
    /// be used at a time.
    /// 
    /// By setting this value to true, the API will return a `marker` field
    /// that can be passed as a parameter to this endpoint to get the next
    /// page of the response.
    public let usemarker: Bool?

    /// Defines the position marker at which to begin returning results. This is
    /// used when paginating using marker-based pagination.
    /// 
    /// This requires `usemarker` to be set to `true`.
    public let marker: String?

    /// Initializer for a GetUsersQueryParams.
    ///
    /// - Parameters:
    ///   - filterTerm: Limits the results to only users who's `name` or
    ///     `login` start with the search term.
    ///     
    ///     For externally managed users, the search term needs
    ///     to completely match the in order to find the user, and
    ///     it will only return one user at a time.
    ///   - userType: Limits the results to the kind of user specified.
    ///     
    ///     * `all` returns every kind of user for whom the
    ///       `login` or `name` partially matches the
    ///       `filter_term`. It will only return an external user
    ///       if the login matches the `filter_term` completely,
    ///       and in that case it will only return that user.
    ///     * `managed` returns all managed and app users for whom
    ///       the `login` or `name` partially matches the
    ///       `filter_term`.
    ///     * `external` returns all external users for whom the
    ///       `login` matches the `filter_term` exactly.
    ///   - externalAppUserId: Limits the results to app users with the given
    ///     `external_app_user_id` value.
    ///     
    ///     When creating an app user, an
    ///     `external_app_user_id` value can be set. This value can
    ///     then be used in this endpoint to find any users that
    ///     match that `external_app_user_id` value.
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
    ///   - usemarker: Specifies whether to use marker-based pagination instead of
    ///     offset-based pagination. Only one pagination method can
    ///     be used at a time.
    ///     
    ///     By setting this value to true, the API will return a `marker` field
    ///     that can be passed as a parameter to this endpoint to get the next
    ///     page of the response.
    ///   - marker: Defines the position marker at which to begin returning results. This is
    ///     used when paginating using marker-based pagination.
    ///     
    ///     This requires `usemarker` to be set to `true`.
    public init(filterTerm: String? = nil, userType: GetUsersQueryParamsUserTypeField? = nil, externalAppUserId: String? = nil, fields: [String]? = nil, offset: Int64? = nil, limit: Int64? = nil, usemarker: Bool? = nil, marker: String? = nil) {
        self.filterTerm = filterTerm
        self.userType = userType
        self.externalAppUserId = externalAppUserId
        self.fields = fields
        self.offset = offset
        self.limit = limit
        self.usemarker = usemarker
        self.marker = marker
    }

}
