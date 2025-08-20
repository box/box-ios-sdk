import Foundation

public class TrashWebLinkRestoredPathCollectionField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case entries
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The number of folders in this list.
    public let totalCount: Int64

    /// The parent folders for this item.
    public let entries: [FolderMini]

    /// Initializer for a TrashWebLinkRestoredPathCollectionField.
    ///
    /// - Parameters:
    ///   - totalCount: The number of folders in this list.
    ///   - entries: The parent folders for this item.
    public init(totalCount: Int64, entries: [FolderMini]) {
        self.totalCount = totalCount
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try container.decode(Int64.self, forKey: .totalCount)
        entries = try container.decode([FolderMini].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalCount, forKey: .totalCount)
        try container.encode(entries, forKey: .entries)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
