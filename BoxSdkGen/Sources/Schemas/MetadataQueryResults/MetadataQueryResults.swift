import Foundation

/// A page of files and folders that matched the metadata query.
public class MetadataQueryResults: Codable {
    private enum CodingKeys: String, CodingKey {
        case entries
        case limit
        case nextMarker = "next_marker"
    }

    /// The mini representation of the files and folders that match the search
    /// terms.
    /// 
    /// By default, this endpoint returns only the most basic info about the
    /// items. To get additional fields for each item, including any of the
    /// metadata, use the `fields` attribute in the query.
    public let entries: [FileFullOrFolderFull]?

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
    public init(entries: [FileFullOrFolderFull]? = nil, limit: Int64? = nil, nextMarker: String? = nil) {
        self.entries = entries
        self.limit = limit
        self.nextMarker = nextMarker
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entries = try container.decodeIfPresent([FileFullOrFolderFull].self, forKey: .entries)
        limit = try container.decodeIfPresent(Int64.self, forKey: .limit)
        nextMarker = try container.decodeIfPresent(String.self, forKey: .nextMarker)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(entries, forKey: .entries)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(nextMarker, forKey: .nextMarker)
    }

}
