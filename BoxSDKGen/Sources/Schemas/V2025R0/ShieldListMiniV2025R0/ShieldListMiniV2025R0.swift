import Foundation

/// A mini representation of a Shield List.
public class ShieldListMiniV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case content
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Unique global identifier for this list.
    public let id: String

    /// Name of Shield List.
    public let name: String

    public let content: ShieldListMiniV2025R0ContentField

    /// The type of object.
    public let type: ShieldListMiniV2025R0TypeField

    /// Initializer for a ShieldListMiniV2025R0.
    ///
    /// - Parameters:
    ///   - id: Unique global identifier for this list.
    ///   - name: Name of Shield List.
    ///   - content: 
    ///   - type: The type of object.
    public init(id: String, name: String, content: ShieldListMiniV2025R0ContentField, type: ShieldListMiniV2025R0TypeField = ShieldListMiniV2025R0TypeField.shieldList) {
        self.id = id
        self.name = name
        self.content = content
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        content = try container.decode(ShieldListMiniV2025R0ContentField.self, forKey: .content)
        type = try container.decode(ShieldListMiniV2025R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(content, forKey: .content)
        try container.encode(type, forKey: .type)
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
