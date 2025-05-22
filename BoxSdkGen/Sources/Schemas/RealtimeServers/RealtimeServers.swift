import Foundation

/// A list of real-time servers that can
/// be used for long-polling.
public class RealtimeServers: Codable {
    private enum CodingKeys: String, CodingKey {
        case chunkSize = "chunk_size"
        case entries
    }

    /// The number of items in this response.
    public let chunkSize: Int64?

    /// A list of real-time servers
    public let entries: [RealtimeServer]?

    /// Initializer for a RealtimeServers.
    ///
    /// - Parameters:
    ///   - chunkSize: The number of items in this response.
    ///   - entries: A list of real-time servers
    public init(chunkSize: Int64? = nil, entries: [RealtimeServer]? = nil) {
        self.chunkSize = chunkSize
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        chunkSize = try container.decodeIfPresent(Int64.self, forKey: .chunkSize)
        entries = try container.decodeIfPresent([RealtimeServer].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(chunkSize, forKey: .chunkSize)
        try container.encodeIfPresent(entries, forKey: .entries)
    }

}
