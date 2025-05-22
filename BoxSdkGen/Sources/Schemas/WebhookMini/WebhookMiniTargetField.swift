import Foundation

public class WebhookMiniTargetField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The ID of the item to trigger a webhook
    public let id: String?

    /// The type of item to trigger a webhook
    public let type: WebhookMiniTargetTypeField?

    /// Initializer for a WebhookMiniTargetField.
    ///
    /// - Parameters:
    ///   - id: The ID of the item to trigger a webhook
    ///   - type: The type of item to trigger a webhook
    public init(id: String? = nil, type: WebhookMiniTargetTypeField? = nil) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(WebhookMiniTargetTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
    }

}
