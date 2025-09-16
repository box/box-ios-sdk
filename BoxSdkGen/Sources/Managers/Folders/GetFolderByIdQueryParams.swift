import Foundation

public class GetFolderByIdQueryParams {
    /// A comma-separated list of attributes to include in the
    /// response. This can be used to request fields that are
    /// not normally returned in a standard response.
    /// 
    /// Be aware that specifying this parameter will have the
    /// effect that none of the standard fields are returned in
    /// the response unless explicitly specified, instead only
    /// fields for the mini representation are returned, additional
    /// to the fields requested.
    /// 
    /// Additionally this field can be used to query any metadata
    /// applied to the file by specifying the `metadata` field as well
    /// as the scope and key of the template to retrieve, for example
    /// `?fields=metadata.enterprise_12345.contractTemplate`.
    public let fields: [String]?

    /// Defines the **second** attribute by which items
    /// are sorted.
    /// 
    /// The folder type affects the way the items
    /// are sorted:
    /// 
    ///   * **Standard folder**:
    ///   Items are always sorted by
    ///   their `type` first, with
    ///   folders listed before files,
    ///   and files listed
    ///   before web links.
    /// 
    ///   * **Root folder**:
    ///   This parameter is not supported
    ///   for marker-based pagination
    ///   on the root folder
    /// 
    ///   (the folder with an `id` of `0`).
    /// 
    ///   * **Shared folder with parent path
    ///   to the associated folder visible to
    ///   the collaborator**:
    ///   Items are always sorted by
    ///   their `type` first, with
    ///   folders listed before files,
    ///   and files listed
    ///   before web links.
    public let sort: GetFolderByIdQueryParamsSortField?

    /// The direction to sort results in. This can be either in alphabetical ascending
    /// (`ASC`) or descending (`DESC`) order.
    public let direction: GetFolderByIdQueryParamsDirectionField?

    /// The offset of the item at which to begin the response.
    /// 
    /// Queries with offset parameter value
    /// exceeding 10000 will be rejected
    /// with a 400 response.
    public let offset: Int64?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetFolderByIdQueryParams.
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
    ///     
    ///     Additionally this field can be used to query any metadata
    ///     applied to the file by specifying the `metadata` field as well
    ///     as the scope and key of the template to retrieve, for example
    ///     `?fields=metadata.enterprise_12345.contractTemplate`.
    ///   - sort: Defines the **second** attribute by which items
    ///     are sorted.
    ///     
    ///     The folder type affects the way the items
    ///     are sorted:
    ///     
    ///       * **Standard folder**:
    ///       Items are always sorted by
    ///       their `type` first, with
    ///       folders listed before files,
    ///       and files listed
    ///       before web links.
    ///     
    ///       * **Root folder**:
    ///       This parameter is not supported
    ///       for marker-based pagination
    ///       on the root folder
    ///     
    ///       (the folder with an `id` of `0`).
    ///     
    ///       * **Shared folder with parent path
    ///       to the associated folder visible to
    ///       the collaborator**:
    ///       Items are always sorted by
    ///       their `type` first, with
    ///       folders listed before files,
    ///       and files listed
    ///       before web links.
    ///   - direction: The direction to sort results in. This can be either in alphabetical ascending
    ///     (`ASC`) or descending (`DESC`) order.
    ///   - offset: The offset of the item at which to begin the response.
    ///     
    ///     Queries with offset parameter value
    ///     exceeding 10000 will be rejected
    ///     with a 400 response.
    ///   - limit: The maximum number of items to return per page.
    public init(fields: [String]? = nil, sort: GetFolderByIdQueryParamsSortField? = nil, direction: GetFolderByIdQueryParamsDirectionField? = nil, offset: Int64? = nil, limit: Int64? = nil) {
        self.fields = fields
        self.sort = sort
        self.direction = direction
        self.offset = offset
        self.limit = limit
    }

}
