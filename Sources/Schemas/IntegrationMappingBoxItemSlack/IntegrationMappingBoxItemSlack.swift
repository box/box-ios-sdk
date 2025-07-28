import Foundation

/// The schema for an integration mapping Box item object for type Slack.
public class IntegrationMappingBoxItemSlack: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// ID of the mapped item (of type referenced in `type`).
    public let id: String

    /// Type of the mapped item referenced in `id`.
    public let type: IntegrationMappingBoxItemSlackTypeField

    /// Initializer for a IntegrationMappingBoxItemSlack.
    ///
    /// - Parameters:
    ///   - id: ID of the mapped item (of type referenced in `type`).
    ///   - type: Type of the mapped item referenced in `id`.
    public init(id: String, type: IntegrationMappingBoxItemSlackTypeField = IntegrationMappingBoxItemSlackTypeField.folder) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(IntegrationMappingBoxItemSlackTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
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
