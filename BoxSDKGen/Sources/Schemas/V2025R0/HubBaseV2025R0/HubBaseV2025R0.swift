import Foundation

/// The bare basic representation of a hub.
public class HubBaseV2025R0: Codable, RawJSONReadable {
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


    /// The unique identifier that represent a hub.
    /// 
    /// The ID for any hub can be determined
    /// by visiting a hub in the web application
    /// and copying the ID from the URL. For example,
    /// for the URL `https://*.app.box.com/hubs/123`
    /// the `hub_id` is `123`.
    public let id: String

    /// The value will always be `hubs`.
    public let type: HubBaseV2025R0TypeField

    /// Initializer for a HubBaseV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a hub.
    ///     
    ///     The ID for any hub can be determined
    ///     by visiting a hub in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/hubs/123`
    ///     the `hub_id` is `123`.
    ///   - type: The value will always be `hubs`.
    public init(id: String, type: HubBaseV2025R0TypeField = HubBaseV2025R0TypeField.hubs) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(HubBaseV2025R0TypeField.self, forKey: .type)
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
