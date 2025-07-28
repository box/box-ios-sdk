import Foundation

/// Represents a configured webhook.
public class WebhookMini: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case target
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for this webhook.
    public let id: String?

    /// The value will always be `webhook`.
    public let type: WebhookMiniTypeField?

    /// The item that will trigger the webhook.
    public let target: WebhookMiniTargetField?

    /// Initializer for a WebhookMini.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this webhook.
    ///   - type: The value will always be `webhook`.
    ///   - target: The item that will trigger the webhook.
    public init(id: String? = nil, type: WebhookMiniTypeField? = nil, target: WebhookMiniTargetField? = nil) {
        self.id = id
        self.type = type
        self.target = target
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(WebhookMiniTypeField.self, forKey: .type)
        target = try container.decodeIfPresent(WebhookMiniTargetField.self, forKey: .target)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(target, forKey: .target)
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
