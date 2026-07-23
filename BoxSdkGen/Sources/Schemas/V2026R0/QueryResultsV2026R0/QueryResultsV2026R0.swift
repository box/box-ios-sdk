import Foundation

/// A paginated list of items matching the query, using milestone-based marker
/// pagination.
public class QueryResultsV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case entries
        case limit
        case nextMarker = "next_marker"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The list of items matching the query predicate.
    public let entries: [QueryResultEntryV2026R0]

    /// The limit that was used for this request. This will be the same as the limit query 
    /// parameter unless that value exceeded the maximum value allowed.
    public let limit: Int

    /// The marker for the start of the next page of results. When `null`, there
    /// are no further results available.
    @CodableTriState public private(set) var nextMarker: String?

    /// Initializer for a QueryResultsV2026R0.
    ///
    /// - Parameters:
    ///   - entries: The list of items matching the query predicate.
    ///   - limit: The limit that was used for this request. This will be the same as the limit query 
    ///     parameter unless that value exceeded the maximum value allowed.
    ///   - nextMarker: The marker for the start of the next page of results. When `null`, there
    ///     are no further results available.
    public init(entries: [QueryResultEntryV2026R0], limit: Int, nextMarker: TriStateField<String> = nil) {
        self.entries = entries
        self.limit = limit
        self._nextMarker = CodableTriState(state: nextMarker)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entries = try container.decode([QueryResultEntryV2026R0].self, forKey: .entries)
        limit = try container.decode(Int.self, forKey: .limit)
        nextMarker = try container.decodeIfPresent(String.self, forKey: .nextMarker)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entries, forKey: .entries)
        try container.encode(limit, forKey: .limit)
        try container.encode(field: _nextMarker.state, forKey: .nextMarker)
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
