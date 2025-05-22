import Foundation

/// A list of folder locks
public class FolderLocks: Codable {
    private enum CodingKeys: String, CodingKey {
        case entries
        case limit
        case nextMarker = "next_marker"
    }

    /// A list of folder locks
    public let entries: [FolderLock]?

    /// The limit that was used for these entries. This will be the same as the
    /// `limit` query parameter unless that value exceeded the maximum value
    /// allowed. The maximum value varies by API.
    public let limit: String?

    /// The marker for the start of the next page of results.
    @CodableTriState public private(set) var nextMarker: String?

    /// Initializer for a FolderLocks.
    ///
    /// - Parameters:
    ///   - entries: A list of folder locks
    ///   - limit: The limit that was used for these entries. This will be the same as the
    ///     `limit` query parameter unless that value exceeded the maximum value
    ///     allowed. The maximum value varies by API.
    ///   - nextMarker: The marker for the start of the next page of results.
    public init(entries: [FolderLock]? = nil, limit: String? = nil, nextMarker: TriStateField<String> = nil) {
        self.entries = entries
        self.limit = limit
        self._nextMarker = CodableTriState(state: nextMarker)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entries = try container.decodeIfPresent([FolderLock].self, forKey: .entries)
        limit = try container.decodeIfPresent(String.self, forKey: .limit)
        nextMarker = try container.decodeIfPresent(String.self, forKey: .nextMarker)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(entries, forKey: .entries)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encode(field: _nextMarker.state, forKey: .nextMarker)
    }

}
