import Foundation

/// Anonymous recipients can request a one-time-passcode only when they
/// enter an email that matches an entry on the `allowlist`.
public class SharedLinkOtpWritableAllowlist: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case allowlist
        case mode
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The list of email and domain entries that are permitted to access the
    /// shared link when `mode` is `allowlist`. Anonymous users whose
    /// email matches an entry can request and verify a one-time-passcode.
    /// 
    /// Providing this field replaces the entire existing allowlist; passing
    /// an empty array clears all entries. Required when `mode` is `allowlist`.
    public let allowlist: [SharedLinkOtpAllowlistEntryWritable]

    /// Set to `allowlist` to restrict OTP requests to emails matching an
    /// entry on the `allowlist`.
    public let mode: SharedLinkOtpWritableAllowlistModeField

    /// Initializer for a SharedLinkOtpWritableAllowlist.
    ///
    /// - Parameters:
    ///   - allowlist: The list of email and domain entries that are permitted to access the
    ///     shared link when `mode` is `allowlist`. Anonymous users whose
    ///     email matches an entry can request and verify a one-time-passcode.
    ///     
    ///     Providing this field replaces the entire existing allowlist; passing
    ///     an empty array clears all entries. Required when `mode` is `allowlist`.
    ///   - mode: Set to `allowlist` to restrict OTP requests to emails matching an
    ///     entry on the `allowlist`.
    public init(allowlist: [SharedLinkOtpAllowlistEntryWritable], mode: SharedLinkOtpWritableAllowlistModeField = SharedLinkOtpWritableAllowlistModeField.allowlist) {
        self.allowlist = allowlist
        self.mode = mode
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        allowlist = try container.decode([SharedLinkOtpAllowlistEntryWritable].self, forKey: .allowlist)
        mode = try container.decode(SharedLinkOtpWritableAllowlistModeField.self, forKey: .mode)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(allowlist, forKey: .allowlist)
        try container.encode(mode, forKey: .mode)
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
