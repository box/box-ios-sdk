import Foundation

public class CreateWebhookRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case target
        case address
        case triggers
    }

    /// The item that will trigger the webhook
    public let target: CreateWebhookRequestBodyTargetField

    /// The URL that is notified by this webhook
    public let address: String

    /// An array of event names that this webhook is
    /// to be triggered for
    public let triggers: [CreateWebhookRequestBodyTriggersField]

    /// Initializer for a CreateWebhookRequestBody.
    ///
    /// - Parameters:
    ///   - target: The item that will trigger the webhook
    ///   - address: The URL that is notified by this webhook
    ///   - triggers: An array of event names that this webhook is
    ///     to be triggered for
    public init(target: CreateWebhookRequestBodyTargetField, address: String, triggers: [CreateWebhookRequestBodyTriggersField]) {
        self.target = target
        self.address = address
        self.triggers = triggers
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        target = try container.decode(CreateWebhookRequestBodyTargetField.self, forKey: .target)
        address = try container.decode(String.self, forKey: .address)
        triggers = try container.decode([CreateWebhookRequestBodyTriggersField].self, forKey: .triggers)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(target, forKey: .target)
        try container.encode(address, forKey: .address)
        try container.encode(triggers, forKey: .triggers)
    }

}
