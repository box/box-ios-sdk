import Foundation

/// Represents a configured webhook.
public class WebhookMini: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case target
    }

    /// The unique identifier for this webhook.
    public let id: String?

    /// `webhook`
    public let type: WebhookMiniTypeField?

    /// The item that will trigger the webhook
    public let target: WebhookMiniTargetField?

    /// Initializer for a WebhookMini.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this webhook.
    ///   - type: `webhook`
    ///   - target: The item that will trigger the webhook
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

}
