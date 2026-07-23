import Foundation

/// Request body describing the query to run, including the filtering predicate,
/// optional sorting, pagination, and the fields to return for each result.
public class QueryRequestBodyV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case query
        case orderBy = "order_by"
        case limit
        case fields
        case marker
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The query definition, including the filtering predicate and its optional
    /// parameters and ancestor restrictions.
    public let query: QueryRequestBodyV2026R0QueryField

    /// The sorting criteria for the result set. Entries are applied sequentially
    /// to define multi-level sorting.
    public let orderBy: [QueryOrderByV2026R0]?

    /// The maximum number of results to return. Defaults to `50` when not
    /// provided.
    public let limit: Int?

    /// Controls which additional fields are included in each result entry. Each
    /// value must be one of: a fully qualified item field key (for example
    /// `box:item:name`), a metadata template key to hydrate the full template (for
    /// example `enterprise_12345678:project`), or a specific metadata template
    /// field key to hydrate a single field from the template (for example
    /// `enterprise_12345678:project:name`). When omitted, entries include only the
    /// item type and identifier.
    public let fields: [String]?

    /// An opaque token returned from a previous response, used to continue
    /// retrieval. When provided, all other request parameters must exactly match
    /// those of the original request.
    public let marker: String?

    /// Initializer for a QueryRequestBodyV2026R0.
    ///
    /// - Parameters:
    ///   - query: The query definition, including the filtering predicate and its optional
    ///     parameters and ancestor restrictions.
    ///   - orderBy: The sorting criteria for the result set. Entries are applied sequentially
    ///     to define multi-level sorting.
    ///   - limit: The maximum number of results to return. Defaults to `50` when not
    ///     provided.
    ///   - fields: Controls which additional fields are included in each result entry. Each
    ///     value must be one of: a fully qualified item field key (for example
    ///     `box:item:name`), a metadata template key to hydrate the full template (for
    ///     example `enterprise_12345678:project`), or a specific metadata template
    ///     field key to hydrate a single field from the template (for example
    ///     `enterprise_12345678:project:name`). When omitted, entries include only the
    ///     item type and identifier.
    ///   - marker: An opaque token returned from a previous response, used to continue
    ///     retrieval. When provided, all other request parameters must exactly match
    ///     those of the original request.
    public init(query: QueryRequestBodyV2026R0QueryField, orderBy: [QueryOrderByV2026R0]? = nil, limit: Int? = nil, fields: [String]? = nil, marker: String? = nil) {
        self.query = query
        self.orderBy = orderBy
        self.limit = limit
        self.fields = fields
        self.marker = marker
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        query = try container.decode(QueryRequestBodyV2026R0QueryField.self, forKey: .query)
        orderBy = try container.decodeIfPresent([QueryOrderByV2026R0].self, forKey: .orderBy)
        limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        fields = try container.decodeIfPresent([String].self, forKey: .fields)
        marker = try container.decodeIfPresent(String.self, forKey: .marker)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(query, forKey: .query)
        try container.encodeIfPresent(orderBy, forKey: .orderBy)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(fields, forKey: .fields)
        try container.encodeIfPresent(marker, forKey: .marker)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
