import Foundation

/// A node object for metadata taxonomy that can be used in metadata templates.
public class MetadataTaxonomyNode: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case level
        case parentId
        case nodePath
        case ancestors
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A unique identifier of the metadata taxonomy node.
    public let id: String

    /// The display name of the metadata taxonomy node.
    public let displayName: String

    /// An index of the level to which the node belongs.
    public let level: Int64

    /// The identifier of the parent node.
    public let parentId: String?

    /// An array of identifiers for all ancestor nodes.  
    /// Not returned for root-level nodes.
    public let nodePath: [String]?

    /// An array of objects for all ancestor nodes.  
    /// Not returned for root-level nodes.
    public let ancestors: [MetadataTaxonomyAncestor]?

    /// Initializer for a MetadataTaxonomyNode.
    ///
    /// - Parameters:
    ///   - id: A unique identifier of the metadata taxonomy node.
    ///   - displayName: The display name of the metadata taxonomy node.
    ///   - level: An index of the level to which the node belongs.
    ///   - parentId: The identifier of the parent node.
    ///   - nodePath: An array of identifiers for all ancestor nodes.  
    ///     Not returned for root-level nodes.
    ///   - ancestors: An array of objects for all ancestor nodes.  
    ///     Not returned for root-level nodes.
    public init(id: String, displayName: String, level: Int64, parentId: String? = nil, nodePath: [String]? = nil, ancestors: [MetadataTaxonomyAncestor]? = nil) {
        self.id = id
        self.displayName = displayName
        self.level = level
        self.parentId = parentId
        self.nodePath = nodePath
        self.ancestors = ancestors
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        displayName = try container.decode(String.self, forKey: .displayName)
        level = try container.decode(Int64.self, forKey: .level)
        parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        nodePath = try container.decodeIfPresent([String].self, forKey: .nodePath)
        ancestors = try container.decodeIfPresent([MetadataTaxonomyAncestor].self, forKey: .ancestors)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(level, forKey: .level)
        try container.encodeIfPresent(parentId, forKey: .parentId)
        try container.encodeIfPresent(nodePath, forKey: .nodePath)
        try container.encodeIfPresent(ancestors, forKey: .ancestors)
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
