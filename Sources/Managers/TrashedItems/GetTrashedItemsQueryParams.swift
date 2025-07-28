import Foundation

public class GetTrashedItemsQueryParams {
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

    /// The direction to sort results in. This can be either in alphabetical ascending
    /// (`ASC`) or descending (`DESC`) order.
    public let direction: GetTrashedItemsQueryParamsDirectionField?

    /// Defines the **second** attribute by which items
    /// are sorted.
    /// 
    /// Items are always sorted by their `type` first, with
    /// folders listed before files, and files listed
    /// before web links.
    /// 
    /// This parameter is not supported when using marker-based pagination.
    public let sort: GetTrashedItemsQueryParamsSortField?

    /// Initializer for a GetTrashedItemsQueryParams.
    ///
    /// - Parameters:
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
    ///   - direction: The direction to sort results in. This can be either in alphabetical ascending
    ///     (`ASC`) or descending (`DESC`) order.
    ///   - sort: Defines the **second** attribute by which items
    ///     are sorted.
    ///     
    ///     Items are always sorted by their `type` first, with
    ///     folders listed before files, and files listed
    ///     before web links.
    ///     
    ///     This parameter is not supported when using marker-based pagination.
    public init(fields: [String]? = nil, limit: Int64? = nil, offset: Int64? = nil, usemarker: Bool? = nil, marker: String? = nil, direction: GetTrashedItemsQueryParamsDirectionField? = nil, sort: GetTrashedItemsQueryParamsSortField? = nil) {
        self.fields = fields
        self.limit = limit
        self.offset = offset
        self.usemarker = usemarker
        self.marker = marker
        self.direction = direction
        self.sort = sort
    }

}
