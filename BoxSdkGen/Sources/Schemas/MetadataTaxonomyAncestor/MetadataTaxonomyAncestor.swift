import Foundation

/// A node object in the metadata taxonomy that represents an ancestor.
public class MetadataTaxonomyAncestor: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case level
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A unique identifier of the metadata taxonomy node.
    public let id: String?

    /// The display name of the metadata taxonomy node.
    public let displayName: String?

    /// An index of the level to which the node belongs.
    public let level: Int64?

    /// Initializer for a MetadataTaxonomyAncestor.
    ///
    /// - Parameters:
    ///   - id: A unique identifier of the metadata taxonomy node.
    ///   - displayName: The display name of the metadata taxonomy node.
    ///   - level: An index of the level to which the node belongs.
    public init(id: String? = nil, displayName: String? = nil, level: Int64? = nil) {
        self.id = id
        self.displayName = displayName
        self.level = level
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        level = try container.decodeIfPresent(Int64.self, forKey: .level)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(displayName, forKey: .displayName)
        try container.encodeIfPresent(level, forKey: .level)
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
