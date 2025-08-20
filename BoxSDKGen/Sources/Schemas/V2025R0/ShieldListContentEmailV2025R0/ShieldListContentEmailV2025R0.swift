import Foundation

/// Representation of content of a Shield List that contains email addresses data.
public class ShieldListContentEmailV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case emailAddresses = "email_addresses"
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// List of emails.
    public let emailAddresses: [String]

    /// The type of content in the shield list.
    public let type: ShieldListContentEmailV2025R0TypeField

    /// Initializer for a ShieldListContentEmailV2025R0.
    ///
    /// - Parameters:
    ///   - emailAddresses: List of emails.
    ///   - type: The type of content in the shield list.
    public init(emailAddresses: [String], type: ShieldListContentEmailV2025R0TypeField = ShieldListContentEmailV2025R0TypeField.email) {
        self.emailAddresses = emailAddresses
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        emailAddresses = try container.decode([String].self, forKey: .emailAddresses)
        type = try container.decode(ShieldListContentEmailV2025R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(emailAddresses, forKey: .emailAddresses)
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
