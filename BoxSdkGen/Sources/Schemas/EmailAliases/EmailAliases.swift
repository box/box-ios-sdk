import Foundation

/// A list of email aliases
public class EmailAliases: Codable {
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case entries
    }

    /// The number of email aliases.
    public let totalCount: Int64?

    /// A list of email aliases
    public let entries: [EmailAlias]?

    /// Initializer for a EmailAliases.
    ///
    /// - Parameters:
    ///   - totalCount: The number of email aliases.
    ///   - entries: A list of email aliases
    public init(totalCount: Int64? = nil, entries: [EmailAlias]? = nil) {
        self.totalCount = totalCount
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try container.decodeIfPresent(Int64.self, forKey: .totalCount)
        entries = try container.decodeIfPresent([EmailAlias].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(totalCount, forKey: .totalCount)
        try container.encodeIfPresent(entries, forKey: .entries)
    }

}
