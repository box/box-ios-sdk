import Foundation

/// A list of file version retentions.
/// 
/// **Note**:
/// File retention API is now **deprecated**. 
/// To get information about files and file versions under retention,
/// see [files under retention](e://get-retention-policy-assignments-id-files-under-retention) or [file versions under retention](e://get-retention-policy-assignments-id-file-versions-under-retention) endpoints.
public class FileVersionRetentions: Codable {
    private enum CodingKeys: String, CodingKey {
        case limit
        case nextMarker = "next_marker"
        case prevMarker = "prev_marker"
        case entries
    }

    /// The limit that was used for these entries. This will be the same as the
    /// `limit` query parameter unless that value exceeded the maximum value
    /// allowed. The maximum value varies by API.
    public let limit: Int64?

    /// The marker for the start of the next page of results.
    @CodableTriState public private(set) var nextMarker: String?

    /// The marker for the start of the previous page of results.
    @CodableTriState public private(set) var prevMarker: String?

    /// A list of file version retentions
    public let entries: [FileVersionRetention]?

    /// Initializer for a FileVersionRetentions.
    ///
    /// - Parameters:
    ///   - limit: The limit that was used for these entries. This will be the same as the
    ///     `limit` query parameter unless that value exceeded the maximum value
    ///     allowed. The maximum value varies by API.
    ///   - nextMarker: The marker for the start of the next page of results.
    ///   - prevMarker: The marker for the start of the previous page of results.
    ///   - entries: A list of file version retentions
    public init(limit: Int64? = nil, nextMarker: TriStateField<String> = nil, prevMarker: TriStateField<String> = nil, entries: [FileVersionRetention]? = nil) {
        self.limit = limit
        self._nextMarker = CodableTriState(state: nextMarker)
        self._prevMarker = CodableTriState(state: prevMarker)
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        limit = try container.decodeIfPresent(Int64.self, forKey: .limit)
        nextMarker = try container.decodeIfPresent(String.self, forKey: .nextMarker)
        prevMarker = try container.decodeIfPresent(String.self, forKey: .prevMarker)
        entries = try container.decodeIfPresent([FileVersionRetention].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encode(field: _nextMarker.state, forKey: .nextMarker)
        try container.encode(field: _prevMarker.state, forKey: .prevMarker)
        try container.encodeIfPresent(entries, forKey: .entries)
    }

}
