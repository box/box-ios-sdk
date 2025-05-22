import Foundation

/// A list of metadata instances that have been applied to a file or folder.
public class Metadatas: Codable {
    private enum CodingKeys: String, CodingKey {
        case entries
        case limit
    }

    /// A list of metadata instances, as applied to this file or folder.
    public let entries: [Metadata]?

    /// The limit that was used for this page of results.
    public let limit: Int64?

    /// Initializer for a Metadatas.
    ///
    /// - Parameters:
    ///   - entries: A list of metadata instances, as applied to this file or folder.
    ///   - limit: The limit that was used for this page of results.
    public init(entries: [Metadata]? = nil, limit: Int64? = nil) {
        self.entries = entries
        self.limit = limit
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entries = try container.decodeIfPresent([Metadata].self, forKey: .entries)
        limit = try container.decodeIfPresent(Int64.self, forKey: .limit)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(entries, forKey: .entries)
        try container.encodeIfPresent(limit, forKey: .limit)
    }

}
