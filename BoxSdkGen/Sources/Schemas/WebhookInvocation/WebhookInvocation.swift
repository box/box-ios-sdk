import Foundation

/// The event that is sent to a webhook address when an event happens.
public class WebhookInvocation: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case webhook
        case createdBy = "created_by"
        case createdAt = "created_at"
        case trigger
        case source
    }

    /// The unique identifier for this webhook invocation
    public let id: String?

    /// `webhook_event`
    public let type: WebhookInvocationTypeField?

    public let webhook: Webhook?

    public let createdBy: UserMini?

    /// A timestamp identifying the time that
    /// the webhook event was triggered.
    public let createdAt: Date?

    public let trigger: WebhookInvocationTriggerField?

    public let source: FileOrFolder?

    /// Initializer for a WebhookInvocation.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this webhook invocation
    ///   - type: `webhook_event`
    ///   - webhook: 
    ///   - createdBy: 
    ///   - createdAt: A timestamp identifying the time that
    ///     the webhook event was triggered.
    ///   - trigger: 
    ///   - source: 
    public init(id: String? = nil, type: WebhookInvocationTypeField? = nil, webhook: Webhook? = nil, createdBy: UserMini? = nil, createdAt: Date? = nil, trigger: WebhookInvocationTriggerField? = nil, source: FileOrFolder? = nil) {
        self.id = id
        self.type = type
        self.webhook = webhook
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.trigger = trigger
        self.source = source
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(WebhookInvocationTypeField.self, forKey: .type)
        webhook = try container.decodeIfPresent(Webhook.self, forKey: .webhook)
        createdBy = try container.decodeIfPresent(UserMini.self, forKey: .createdBy)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        trigger = try container.decodeIfPresent(WebhookInvocationTriggerField.self, forKey: .trigger)
        source = try container.decodeIfPresent(FileOrFolder.self, forKey: .source)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(webhook, forKey: .webhook)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeIfPresent(trigger, forKey: .trigger)
        try container.encodeIfPresent(source, forKey: .source)
    }

}
