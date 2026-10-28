import Foundation

/// An entry used to write the OTP allowlist for a shared link. The entry can
/// match either a specific email address or every email address that
/// belongs to a domain.
public class SharedLinkOtpAllowlistEntryWritable: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The kind of allowlist entry.
    /// 
    /// * `email` - The entry matches a single email address.
    /// * `domain` - The entry matches every email address under the
    ///   given domain.
    public let type: SharedLinkOtpAllowlistEntryWritableTypeField

    /// The value of the allowlist entry.
    /// 
    /// * For `email` entries, the full email address (must contain `@`).
    /// * For `domain` entries, the bare domain (e.g. `example.com`).
    public let value: String

    /// Initializer for a SharedLinkOtpAllowlistEntryWritable.
    ///
    /// - Parameters:
    ///   - type: The kind of allowlist entry.
    ///     
    ///     * `email` - The entry matches a single email address.
    ///     * `domain` - The entry matches every email address under the
    ///       given domain.
    ///   - value: The value of the allowlist entry.
    ///     
    ///     * For `email` entries, the full email address (must contain `@`).
    ///     * For `domain` entries, the bare domain (e.g. `example.com`).
    public init(type: SharedLinkOtpAllowlistEntryWritableTypeField, value: String) {
        self.type = type
        self.value = value
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(SharedLinkOtpAllowlistEntryWritableTypeField.self, forKey: .type)
        value = try container.decode(String.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(value, forKey: .value)
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
