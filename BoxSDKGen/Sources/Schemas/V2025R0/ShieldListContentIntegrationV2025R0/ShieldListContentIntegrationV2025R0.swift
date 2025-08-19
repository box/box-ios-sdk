import Foundation

/// Representation of content of a Shield List that contains integrations data.
public class ShieldListContentIntegrationV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case integrations
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// List of integration.
    public let integrations: [ShieldListContentIntegrationV2025R0IntegrationsField]

    /// The type of content in the shield list.
    public let type: ShieldListContentIntegrationV2025R0TypeField

    /// Initializer for a ShieldListContentIntegrationV2025R0.
    ///
    /// - Parameters:
    ///   - integrations: List of integration.
    ///   - type: The type of content in the shield list.
    public init(integrations: [ShieldListContentIntegrationV2025R0IntegrationsField], type: ShieldListContentIntegrationV2025R0TypeField = ShieldListContentIntegrationV2025R0TypeField.integration) {
        self.integrations = integrations
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        integrations = try container.decode([ShieldListContentIntegrationV2025R0IntegrationsField].self, forKey: .integrations)
        type = try container.decode(ShieldListContentIntegrationV2025R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(integrations, forKey: .integrations)
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
