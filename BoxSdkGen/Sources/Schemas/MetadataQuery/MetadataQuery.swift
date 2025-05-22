import Foundation

/// Create a search using SQL-like syntax to return items that match specific
/// metadata.
public class MetadataQuery: Codable {
    private enum CodingKeys: String, CodingKey {
        case from
        case ancestorFolderId = "ancestor_folder_id"
        case query
        case queryParams = "query_params"
        case orderBy = "order_by"
        case limit
        case marker
        case fields
    }

    /// Specifies the template used in the query. Must be in the form
    /// `scope.templateKey`. Not all templates can be used in this field,
    /// most notably the built-in, Box-provided classification templates
    /// can not be used in a query.
    public let from: String

    /// The ID of the folder that you are restricting the query to. A
    /// value of zero will return results from all folders you have access
    /// to. A non-zero value will only return results found in the folder
    /// corresponding to the ID or in any of its subfolders.
    public let ancestorFolderId: String

    /// The query to perform. A query is a logical expression that is very similar
    /// to a SQL `SELECT` statement. Values in the search query can be turned into
    /// parameters specified in the `query_param` arguments list to prevent having
    /// to manually insert search values into the query string.
    /// 
    /// For example, a value of `:amount` would represent the `amount` value in
    /// `query_params` object.
    public let query: String?

    /// Set of arguments corresponding to the parameters specified in the
    /// `query`. The type of each parameter used in the `query_params` must match
    /// the type of the corresponding metadata template field.
    public let queryParams: [String: AnyCodable]?

    /// A list of template fields and directions to sort the metadata query
    /// results by.
    /// 
    /// The ordering `direction` must be the same for each item in the array.
    public let orderBy: [MetadataQueryOrderByField]?

    /// A value between 0 and 100 that indicates the maximum number of results
    /// to return for a single request. This only specifies a maximum
    /// boundary and will not guarantee the minimum number of results
    /// returned.
    public let limit: Int64?

    /// Marker to use for requesting the next page.
    public let marker: String?

    /// By default, this endpoint returns only the most basic info about the items for
    /// which the query matches. This attribute can be used to specify a list of
    /// additional attributes to return for any item, including its metadata.
    /// 
    /// This attribute takes a list of item fields, metadata template identifiers,
    /// or metadata template field identifiers.
    /// 
    /// For example:
    /// 
    /// * `created_by` will add the details of the user who created the item to
    /// the response.
    /// * `metadata.<scope>.<templateKey>` will return the mini-representation
    /// of the metadata instance identified by the `scope` and `templateKey`.
    /// * `metadata.<scope>.<templateKey>.<field>` will return all the mini-representation
    /// of the metadata instance identified by the `scope` and `templateKey` plus
    /// the field specified by the `field` name. Multiple fields for the same
    /// `scope` and `templateKey` can be defined.
    public let fields: [String]?

    /// Initializer for a MetadataQuery.
    ///
    /// - Parameters:
    ///   - from: Specifies the template used in the query. Must be in the form
    ///     `scope.templateKey`. Not all templates can be used in this field,
    ///     most notably the built-in, Box-provided classification templates
    ///     can not be used in a query.
    ///   - ancestorFolderId: The ID of the folder that you are restricting the query to. A
    ///     value of zero will return results from all folders you have access
    ///     to. A non-zero value will only return results found in the folder
    ///     corresponding to the ID or in any of its subfolders.
    ///   - query: The query to perform. A query is a logical expression that is very similar
    ///     to a SQL `SELECT` statement. Values in the search query can be turned into
    ///     parameters specified in the `query_param` arguments list to prevent having
    ///     to manually insert search values into the query string.
    ///     
    ///     For example, a value of `:amount` would represent the `amount` value in
    ///     `query_params` object.
    ///   - queryParams: Set of arguments corresponding to the parameters specified in the
    ///     `query`. The type of each parameter used in the `query_params` must match
    ///     the type of the corresponding metadata template field.
    ///   - orderBy: A list of template fields and directions to sort the metadata query
    ///     results by.
    ///     
    ///     The ordering `direction` must be the same for each item in the array.
    ///   - limit: A value between 0 and 100 that indicates the maximum number of results
    ///     to return for a single request. This only specifies a maximum
    ///     boundary and will not guarantee the minimum number of results
    ///     returned.
    ///   - marker: Marker to use for requesting the next page.
    ///   - fields: By default, this endpoint returns only the most basic info about the items for
    ///     which the query matches. This attribute can be used to specify a list of
    ///     additional attributes to return for any item, including its metadata.
    ///     
    ///     This attribute takes a list of item fields, metadata template identifiers,
    ///     or metadata template field identifiers.
    ///     
    ///     For example:
    ///     
    ///     * `created_by` will add the details of the user who created the item to
    ///     the response.
    ///     * `metadata.<scope>.<templateKey>` will return the mini-representation
    ///     of the metadata instance identified by the `scope` and `templateKey`.
    ///     * `metadata.<scope>.<templateKey>.<field>` will return all the mini-representation
    ///     of the metadata instance identified by the `scope` and `templateKey` plus
    ///     the field specified by the `field` name. Multiple fields for the same
    ///     `scope` and `templateKey` can be defined.
    public init(from: String, ancestorFolderId: String, query: String? = nil, queryParams: [String: AnyCodable]? = nil, orderBy: [MetadataQueryOrderByField]? = nil, limit: Int64? = nil, marker: String? = nil, fields: [String]? = nil) {
        self.from = from
        self.ancestorFolderId = ancestorFolderId
        self.query = query
        self.queryParams = queryParams
        self.orderBy = orderBy
        self.limit = limit
        self.marker = marker
        self.fields = fields
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        from = try container.decode(String.self, forKey: .from)
        ancestorFolderId = try container.decode(String.self, forKey: .ancestorFolderId)
        query = try container.decodeIfPresent(String.self, forKey: .query)
        queryParams = try container.decodeIfPresent([String: AnyCodable].self, forKey: .queryParams)
        orderBy = try container.decodeIfPresent([MetadataQueryOrderByField].self, forKey: .orderBy)
        limit = try container.decodeIfPresent(Int64.self, forKey: .limit)
        marker = try container.decodeIfPresent(String.self, forKey: .marker)
        fields = try container.decodeIfPresent([String].self, forKey: .fields)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(from, forKey: .from)
        try container.encode(ancestorFolderId, forKey: .ancestorFolderId)
        try container.encodeIfPresent(query, forKey: .query)
        try container.encodeIfPresent(queryParams, forKey: .queryParams)
        try container.encodeIfPresent(orderBy, forKey: .orderBy)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(marker, forKey: .marker)
        try container.encodeIfPresent(fields, forKey: .fields)
    }

}
