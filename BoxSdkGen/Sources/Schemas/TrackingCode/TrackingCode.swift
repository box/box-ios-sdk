import Foundation

/// Tracking codes allow an admin to generate reports from the admin console
/// and assign an attribute to a specific group of users.
/// This setting must be enabled for an enterprise before it can be used.
public class TrackingCode: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case name
        case value
    }

    /// `tracking_code`
    public let type: TrackingCodeTypeField?

    /// The name of the tracking code, which must be preconfigured in
    /// the Admin Console
    public let name: String?

    /// The value of the tracking code
    public let value: String?

    /// Initializer for a TrackingCode.
    ///
    /// - Parameters:
    ///   - type: `tracking_code`
    ///   - name: The name of the tracking code, which must be preconfigured in
    ///     the Admin Console
    ///   - value: The value of the tracking code
    public init(type: TrackingCodeTypeField? = nil, name: String? = nil, value: String? = nil) {
        self.type = type
        self.name = name
        self.value = value
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(TrackingCodeTypeField.self, forKey: .type)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        value = try container.decodeIfPresent(String.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(value, forKey: .value)
    }

}
