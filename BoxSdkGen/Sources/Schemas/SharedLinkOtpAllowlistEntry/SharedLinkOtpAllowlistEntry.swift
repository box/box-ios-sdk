import Foundation

/// An entry on the OTP allowlist for a shared link. The entry can match
/// either a specific email address or every email address that belongs to
/// a domain.
public class SharedLinkOtpAllowlistEntry: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case value
        case createdAt = "created_at"
        case createdBy = "created_by"
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
    public let type: SharedLinkOtpAllowlistEntryTypeField

    /// The value of the allowlist entry.
    /// 
    /// * For `email` entries, the full email address (must contain `@`).
    /// * For `domain` entries, the bare domain (e.g. `example.com`).
    public let value: String

    /// The date and time when the allowlist entry was added.
    public let createdAt: Date

    public let createdBy: UserBase

    /// Initializer for a SharedLinkOtpAllowlistEntry.
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
    ///   - createdAt: The date and time when the allowlist entry was added.
    ///   - createdBy: 
    public init(type: SharedLinkOtpAllowlistEntryTypeField, value: String, createdAt: Date, createdBy: UserBase) {
        self.type = type
        self.value = value
        self.createdAt = createdAt
        self.createdBy = createdBy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(SharedLinkOtpAllowlistEntryTypeField.self, forKey: .type)
        value = try container.decode(String.self, forKey: .value)
        createdAt = try container.decodeDateTime(forKey: .createdAt)
        createdBy = try container.decode(UserBase.self, forKey: .createdBy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(value, forKey: .value)
        try container.encodeDateTime(field: createdAt, forKey: .createdAt)
        try container.encode(createdBy, forKey: .createdBy)
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
