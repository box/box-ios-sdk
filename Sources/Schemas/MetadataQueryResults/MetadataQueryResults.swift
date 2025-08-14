import Foundation

/// A page of files and folders that matched the metadata query.
public class MetadataQueryResults: Codable, RawJSONReadable {
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


    /// The mini representation of the files and folders that match the search
    /// terms.
    /// 
    /// By default, this endpoint returns only the most basic info about the
    /// items. To get additional fields for each item, including any of the
    /// metadata, use the `fields` attribute in the query.
    public let entries: [MetadataQueryResultItem]?

    /// The limit that was used for this search. This will be the same as the
    /// `limit` query parameter unless that value exceeded the maximum value
    /// allowed.
    public let limit: Int64?

    /// The marker for the start of the next page of results.
    public let nextMarker: String?

    /// Initializer for a MetadataQueryResults.
    ///
    /// - Parameters:
    ///   - entries: The mini representation of the files and folders that match the search
    ///     terms.
    ///     
    ///     By default, this endpoint returns only the most basic info about the
    ///     items. To get additional fields for each item, including any of the
    ///     metadata, use the `fields` attribute in the query.
    ///   - limit: The limit that was used for this search. This will be the same as the
    ///     `limit` query parameter unless that value exceeded the maximum value
    ///     allowed.
    ///   - nextMarker: The marker for the start of the next page of results.
    public init(entries: [MetadataQueryResultItem]? = nil, limit: Int64? = nil, nextMarker: String? = nil) {
        self.entries = entries
        self.limit = limit
        self.nextMarker = nextMarker
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entries = try container.decodeIfPresent([MetadataQueryResultItem].self, forKey: .entries)
        limit = try container.decodeIfPresent(Int64.self, forKey: .limit)
        nextMarker = try container.decodeIfPresent(String.self, forKey: .nextMarker)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(entries, forKey: .entries)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(nextMarker, forKey: .nextMarker)
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
