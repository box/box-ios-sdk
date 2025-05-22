import Foundation

/// A list of files
public class Files: Codable {
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case entries
    }

    /// The number of files.
    public let totalCount: Int64?

    /// A list of files
    public let entries: [FileFull]?

    /// Initializer for a Files.
    ///
    /// - Parameters:
    ///   - totalCount: The number of files.
    ///   - entries: A list of files
    public init(totalCount: Int64? = nil, entries: [FileFull]? = nil) {
        self.totalCount = totalCount
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try container.decodeIfPresent(Int64.self, forKey: .totalCount)
        entries = try container.decodeIfPresent([FileFull].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(totalCount, forKey: .totalCount)
        try container.encodeIfPresent(entries, forKey: .entries)
    }

}
