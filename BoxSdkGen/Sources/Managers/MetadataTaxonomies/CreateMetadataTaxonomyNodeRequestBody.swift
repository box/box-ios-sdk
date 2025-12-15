import Foundation

public class CreateMetadataTaxonomyNodeRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case displayName
        case level
        case parentId
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The display name of the taxonomy node.
    public let displayName: String

    /// The level of the taxonomy node.
    public let level: Int64

    /// The identifier of the parent taxonomy node. 
    /// Omit this field for root-level nodes.
    public let parentId: String?

    /// Initializer for a CreateMetadataTaxonomyNodeRequestBody.
    ///
    /// - Parameters:
    ///   - displayName: The display name of the taxonomy node.
    ///   - level: The level of the taxonomy node.
    ///   - parentId: The identifier of the parent taxonomy node. 
    ///     Omit this field for root-level nodes.
    public init(displayName: String, level: Int64, parentId: String? = nil) {
        self.displayName = displayName
        self.level = level
        self.parentId = parentId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try container.decode(String.self, forKey: .displayName)
        level = try container.decode(Int64.self, forKey: .level)
        parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(level, forKey: .level)
        try container.encodeIfPresent(parentId, forKey: .parentId)
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
