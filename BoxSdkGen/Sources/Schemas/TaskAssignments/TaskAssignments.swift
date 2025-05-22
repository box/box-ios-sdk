import Foundation

/// A list of task assignments
public class TaskAssignments: Codable {
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case entries
    }

    /// The total number of items in this collection.
    public let totalCount: Int64?

    /// A list of task assignments
    public let entries: [TaskAssignment]?

    /// Initializer for a TaskAssignments.
    ///
    /// - Parameters:
    ///   - totalCount: The total number of items in this collection.
    ///   - entries: A list of task assignments
    public init(totalCount: Int64? = nil, entries: [TaskAssignment]? = nil) {
        self.totalCount = totalCount
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try container.decodeIfPresent(Int64.self, forKey: .totalCount)
        entries = try container.decodeIfPresent([TaskAssignment].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(totalCount, forKey: .totalCount)
        try container.encodeIfPresent(entries, forKey: .entries)
    }

}
