import Foundation

/// A list of tasks
public class Tasks: Codable {
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case entries
    }

    /// One greater than the offset of the last entry in the entire collection.
    /// The total number of entries in the collection may be less than
    /// `total_count`.
    public let totalCount: Int64?

    /// A list of tasks
    public let entries: [Task]?

    /// Initializer for a Tasks.
    ///
    /// - Parameters:
    ///   - totalCount: One greater than the offset of the last entry in the entire collection.
    ///     The total number of entries in the collection may be less than
    ///     `total_count`.
    ///   - entries: A list of tasks
    public init(totalCount: Int64? = nil, entries: [Task]? = nil) {
        self.totalCount = totalCount
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try container.decodeIfPresent(Int64.self, forKey: .totalCount)
        entries = try container.decodeIfPresent([Task].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(totalCount, forKey: .totalCount)
        try container.encodeIfPresent(entries, forKey: .entries)
    }

}
