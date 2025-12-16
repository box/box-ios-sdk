import Foundation

/// A level in the metadata taxonomy represents a hierarchical category 
/// within the taxonomy structure.
public class MetadataTaxonomyLevel: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case displayName
        case description
        case level
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The display name of the level as it is shown to the user.
    public let displayName: String?

    /// A description of the level.
    public let description: String?

    /// An index of the level within the taxonomy. Levels are indexed starting from 1.
    public let level: Int?

    /// Initializer for a MetadataTaxonomyLevel.
    ///
    /// - Parameters:
    ///   - displayName: The display name of the level as it is shown to the user.
    ///   - description: A description of the level.
    ///   - level: An index of the level within the taxonomy. Levels are indexed starting from 1.
    public init(displayName: String? = nil, description: String? = nil, level: Int? = nil) {
        self.displayName = displayName
        self.description = description
        self.level = level
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        level = try container.decodeIfPresent(Int.self, forKey: .level)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(displayName, forKey: .displayName)
        try container.encodeIfPresent(description, forKey: .description)
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
