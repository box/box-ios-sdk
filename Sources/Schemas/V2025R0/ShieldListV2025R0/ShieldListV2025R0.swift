import Foundation

/// A standard representation of a Shield List.
public class ShieldListV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
        case enterprise
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case content
        case description
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Unique identifier for the shield list.
    public let id: String

    /// Type of the object.
    public let type: String

    /// Name of the shield list.
    public let name: String

    public let enterprise: EnterpriseReferenceV2025R0

    /// ISO date time string when this shield list object was created.
    public let createdAt: Date

    /// ISO date time string when this shield list object was updated.
    public let updatedAt: Date

    public let content: ShieldListContentV2025R0

    /// Description of Shield List.
    public let description: String?

    /// Initializer for a ShieldListV2025R0.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the shield list.
    ///   - type: Type of the object.
    ///   - name: Name of the shield list.
    ///   - enterprise: 
    ///   - createdAt: ISO date time string when this shield list object was created.
    ///   - updatedAt: ISO date time string when this shield list object was updated.
    ///   - content: 
    ///   - description: Description of Shield List.
    public init(id: String, type: String, name: String, enterprise: EnterpriseReferenceV2025R0, createdAt: Date, updatedAt: Date, content: ShieldListContentV2025R0, description: String? = nil) {
        self.id = id
        self.type = type
        self.name = name
        self.enterprise = enterprise
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.content = content
        self.description = description
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        name = try container.decode(String.self, forKey: .name)
        enterprise = try container.decode(EnterpriseReferenceV2025R0.self, forKey: .enterprise)
        createdAt = try container.decodeDateTime(forKey: .createdAt)
        updatedAt = try container.decodeDateTime(forKey: .updatedAt)
        content = try container.decode(ShieldListContentV2025R0.self, forKey: .content)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(enterprise, forKey: .enterprise)
        try container.encodeDateTime(field: createdAt, forKey: .createdAt)
        try container.encodeDateTime(field: updatedAt, forKey: .updatedAt)
        try container.encode(content, forKey: .content)
        try container.encodeIfPresent(description, forKey: .description)
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
