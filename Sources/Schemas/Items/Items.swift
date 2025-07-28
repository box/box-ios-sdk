import Foundation

/// A list of files, folders, and web links in
/// their mini representation.
public class Items: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case limit
        case nextMarker = "next_marker"
        case prevMarker = "prev_marker"
        case totalCount = "total_count"
        case offset
        case order
        case entries
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The limit that was used for these entries. This will be the same as the
    /// `limit` query parameter unless that value exceeded the maximum value
    /// allowed. The maximum value varies by API.
    public let limit: Int64?

    /// The marker for the start of the next page of results.
    @CodableTriState public private(set) var nextMarker: String?

    /// The marker for the start of the previous page of results.
    @CodableTriState public private(set) var prevMarker: String?

    /// One greater than the offset of the last entry in the entire collection.
    /// The total number of entries in the collection may be less than
    /// `total_count`.
    /// 
    /// This field is only returned for calls that use offset-based pagination.
    /// For marker-based paginated APIs, this field will be omitted.
    public let totalCount: Int64?

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
    public let order: [ItemsOrderField]?

    /// The items in this collection.
    public let entries: [FileFullOrFolderMiniOrWebLink]?

    /// Initializer for a Items.
    ///
    /// - Parameters:
    ///   - limit: The limit that was used for these entries. This will be the same as the
    ///     `limit` query parameter unless that value exceeded the maximum value
    ///     allowed. The maximum value varies by API.
    ///   - nextMarker: The marker for the start of the next page of results.
    ///   - prevMarker: The marker for the start of the previous page of results.
    ///   - totalCount: One greater than the offset of the last entry in the entire collection.
    ///     The total number of entries in the collection may be less than
    ///     `total_count`.
    ///     
    ///     This field is only returned for calls that use offset-based pagination.
    ///     For marker-based paginated APIs, this field will be omitted.
    ///   - offset: The 0-based offset of the first entry in this set. This will be the same
    ///     as the `offset` query parameter.
    ///     
    ///     This field is only returned for calls that use offset-based pagination.
    ///     For marker-based paginated APIs, this field will be omitted.
    ///   - order: The order by which items are returned.
    ///     
    ///     This field is only returned for calls that use offset-based pagination.
    ///     For marker-based paginated APIs, this field will be omitted.
    ///   - entries: The items in this collection.
    public init(limit: Int64? = nil, nextMarker: TriStateField<String> = nil, prevMarker: TriStateField<String> = nil, totalCount: Int64? = nil, offset: Int64? = nil, order: [ItemsOrderField]? = nil, entries: [FileFullOrFolderMiniOrWebLink]? = nil) {
        self.limit = limit
        self._nextMarker = CodableTriState(state: nextMarker)
        self._prevMarker = CodableTriState(state: prevMarker)
        self.totalCount = totalCount
        self.offset = offset
        self.order = order
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        limit = try container.decodeIfPresent(Int64.self, forKey: .limit)
        nextMarker = try container.decodeIfPresent(String.self, forKey: .nextMarker)
        prevMarker = try container.decodeIfPresent(String.self, forKey: .prevMarker)
        totalCount = try container.decodeIfPresent(Int64.self, forKey: .totalCount)
        offset = try container.decodeIfPresent(Int64.self, forKey: .offset)
        order = try container.decodeIfPresent([ItemsOrderField].self, forKey: .order)
        entries = try container.decodeIfPresent([FileFullOrFolderMiniOrWebLink].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encode(field: _nextMarker.state, forKey: .nextMarker)
        try container.encode(field: _prevMarker.state, forKey: .prevMarker)
        try container.encodeIfPresent(totalCount, forKey: .totalCount)
        try container.encodeIfPresent(offset, forKey: .offset)
        try container.encodeIfPresent(order, forKey: .order)
        try container.encodeIfPresent(entries, forKey: .entries)
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
