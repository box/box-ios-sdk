import Foundation

/// Represents a configured webhook.
public class Webhook: WebhookMini {
    private enum CodingKeys: String, CodingKey {
        case createdBy = "created_by"
        case createdAt = "created_at"
        case address
        case triggers
    }

    public let createdBy: UserMini?

    /// A timestamp identifying the time that
    /// the webhook was created.
    public let createdAt: Date?

    /// The URL that is notified by this webhook
    public let address: String?

    /// An array of event names that this webhook is
    /// to be triggered for
    public let triggers: [WebhookTriggersField]?

    /// Initializer for a Webhook.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this webhook.
    ///   - type: `webhook`
    ///   - target: The item that will trigger the webhook
    ///   - createdBy: 
    ///   - createdAt: A timestamp identifying the time that
    ///     the webhook was created.
    ///   - address: The URL that is notified by this webhook
    ///   - triggers: An array of event names that this webhook is
    ///     to be triggered for
    public init(id: String? = nil, type: WebhookMiniTypeField? = nil, target: WebhookMiniTargetField? = nil, createdBy: UserMini? = nil, createdAt: Date? = nil, address: String? = nil, triggers: [WebhookTriggersField]? = nil) {
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.address = address
        self.triggers = triggers

        super.init(id: id, type: type, target: target)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdBy = try container.decodeIfPresent(UserMini.self, forKey: .createdBy)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        triggers = try container.decodeIfPresent([WebhookTriggersField].self, forKey: .triggers)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(triggers, forKey: .triggers)
        try super.encode(to: encoder)
    }

}
