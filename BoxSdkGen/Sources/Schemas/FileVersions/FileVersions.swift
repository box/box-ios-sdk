import Foundation

/// A list of file versions
public class FileVersions: Codable {
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case limit
        case offset
        case order
        case entries
    }

    /// One greater than the offset of the last entry in the entire collection.
    /// The total number of entries in the collection may be less than
    /// `total_count`.
    /// 
    /// This field is only returned for calls that use offset-based pagination.
    /// For marker-based paginated APIs, this field will be omitted.
    public let totalCount: Int64?

    /// The limit that was used for these entries. This will be the same as the
    /// `limit` query parameter unless that value exceeded the maximum value
    /// allowed. The maximum value varies by API.
    public let limit: Int64?

    /// The 0-based offset of the first entry in this set. This will be the same
    /// as the `offset` query parameter.
    /// 
    /// This field is only returned for calls that use offset-based pagination.
    /// For marker-based paginated APIs, this field will be omitted.
    public let offset: Int64?

    /// The order by which items are returned.
    /// 
    /// This field is only returned for calls that use offset-based pagination.
    /// For marker-based paginated APIs, this field will be omitted.
    public let order: [FileVersionsOrderField]?

    /// A list of file versions
    public let entries: [FileVersionFull]?

    /// Initializer for a FileVersions.
    ///
    /// - Parameters:
    ///   - totalCount: One greater than the offset of the last entry in the entire collection.
    ///     The total number of entries in the collection may be less than
    ///     `total_count`.
    ///     
    ///     This field is only returned for calls that use offset-based pagination.
    ///     For marker-based paginated APIs, this field will be omitted.
    ///   - limit: The limit that was used for these entries. This will be the same as the
    ///     `limit` query parameter unless that value exceeded the maximum value
    ///     allowed. The maximum value varies by API.
    ///   - offset: The 0-based offset of the first entry in this set. This will be the same
    ///     as the `offset` query parameter.
    ///     
    ///     This field is only returned for calls that use offset-based pagination.
    ///     For marker-based paginated APIs, this field will be omitted.
    ///   - order: The order by which items are returned.
    ///     
    ///     This field is only returned for calls that use offset-based pagination.
    ///     For marker-based paginated APIs, this field will be omitted.
    ///   - entries: A list of file versions
    public init(totalCount: Int64? = nil, limit: Int64? = nil, offset: Int64? = nil, order: [FileVersionsOrderField]? = nil, entries: [FileVersionFull]? = nil) {
        self.totalCount = totalCount
        self.limit = limit
        self.offset = offset
        self.order = order
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try container.decodeIfPresent(Int64.self, forKey: .totalCount)
        limit = try container.decodeIfPresent(Int64.self, forKey: .limit)
        offset = try container.decodeIfPresent(Int64.self, forKey: .offset)
        order = try container.decodeIfPresent([FileVersionsOrderField].self, forKey: .order)
        entries = try container.decodeIfPresent([FileVersionFull].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(totalCount, forKey: .totalCount)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(offset, forKey: .offset)
        try container.encodeIfPresent(order, forKey: .order)
        try container.encodeIfPresent(entries, forKey: .entries)
    }

}
