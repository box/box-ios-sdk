import Foundation

public class TrashFilePathCollectionField: Codable {
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case entries
    }

    /// The number of folders in this list.
    public let totalCount: Int64

    /// Array of folders for this item's path collection
    public let entries: [TrashFilePathCollectionEntriesField]

    /// Initializer for a TrashFilePathCollectionField.
    ///
    /// - Parameters:
    ///   - totalCount: The number of folders in this list.
    ///   - entries: Array of folders for this item's path collection
    public init(totalCount: Int64, entries: [TrashFilePathCollectionEntriesField]) {
        self.totalCount = totalCount
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try container.decode(Int64.self, forKey: .totalCount)
        entries = try container.decode([TrashFilePathCollectionEntriesField].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalCount, forKey: .totalCount)
        try container.encode(entries, forKey: .entries)
    }

}
