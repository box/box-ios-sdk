import Foundation

public class UpdateWebhookByIdRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case target
        case address
        case triggers
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The item that will trigger the webhook.
    public let target: UpdateWebhookByIdRequestBodyTargetField?

    /// The URL that is notified by this webhook.
    public let address: String?

    /// An array of event names that this webhook is
    /// to be triggered for.
    public let triggers: [UpdateWebhookByIdRequestBodyTriggersField]?

    /// Initializer for a UpdateWebhookByIdRequestBody.
    ///
    /// - Parameters:
    ///   - target: The item that will trigger the webhook.
    ///   - address: The URL that is notified by this webhook.
    ///   - triggers: An array of event names that this webhook is
    ///     to be triggered for.
    public init(target: UpdateWebhookByIdRequestBodyTargetField? = nil, address: String? = nil, triggers: [UpdateWebhookByIdRequestBodyTriggersField]? = nil) {
        self.target = target
        self.address = address
        self.triggers = triggers
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        target = try container.decodeIfPresent(UpdateWebhookByIdRequestBodyTargetField.self, forKey: .target)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        triggers = try container.decodeIfPresent([UpdateWebhookByIdRequestBodyTriggersField].self, forKey: .triggers)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(target, forKey: .target)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(triggers, forKey: .triggers)
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
