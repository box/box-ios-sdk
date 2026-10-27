import Foundation

public class ShuttleJobV2026R0SourceSystemField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for the source system.
    public let id: String

    /// The human-readable name of the source system.
    public let name: String

    /// The value will always be `shuttle_system`.
    public let type: ShuttleJobV2026R0SourceSystemTypeField

    /// Initializer for a ShuttleJobV2026R0SourceSystemField.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the source system.
    ///   - name: The human-readable name of the source system.
    ///   - type: The value will always be `shuttle_system`.
    public init(id: String, name: String, type: ShuttleJobV2026R0SourceSystemTypeField = ShuttleJobV2026R0SourceSystemTypeField.shuttleSystem) {
        self.id = id
        self.name = name
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(ShuttleJobV2026R0SourceSystemTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
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
