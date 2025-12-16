import Foundation

/// A taxonomy object for metadata that can be used in metadata templates.
public class MetadataTaxonomy: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case namespace
        case key
        case levels
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A unique identifier of the metadata taxonomy.
    public let id: String

    /// The display name of the metadata taxonomy. This can be seen in the Box web app.
    public let displayName: String

    /// A namespace that the metadata taxonomy is associated with.
    public let namespace: String

    /// A unique identifier of the metadata taxonomy. The identifier must be unique within 
    /// the namespace to which it belongs.
    public let key: String?

    /// Levels of the metadata taxonomy.
    public let levels: [MetadataTaxonomyLevel]?

    /// Initializer for a MetadataTaxonomy.
    ///
    /// - Parameters:
    ///   - id: A unique identifier of the metadata taxonomy.
    ///   - displayName: The display name of the metadata taxonomy. This can be seen in the Box web app.
    ///   - namespace: A namespace that the metadata taxonomy is associated with.
    ///   - key: A unique identifier of the metadata taxonomy. The identifier must be unique within 
    ///     the namespace to which it belongs.
    ///   - levels: Levels of the metadata taxonomy.
    public init(id: String, displayName: String, namespace: String, key: String? = nil, levels: [MetadataTaxonomyLevel]? = nil) {
        self.id = id
        self.displayName = displayName
        self.namespace = namespace
        self.key = key
        self.levels = levels
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        displayName = try container.decode(String.self, forKey: .displayName)
        namespace = try container.decode(String.self, forKey: .namespace)
        key = try container.decodeIfPresent(String.self, forKey: .key)
        levels = try container.decodeIfPresent([MetadataTaxonomyLevel].self, forKey: .levels)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(namespace, forKey: .namespace)
        try container.encodeIfPresent(key, forKey: .key)
        try container.encodeIfPresent(levels, forKey: .levels)
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
