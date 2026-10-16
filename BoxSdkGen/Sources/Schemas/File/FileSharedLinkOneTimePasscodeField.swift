import Foundation

public class FileSharedLinkOneTimePasscodeField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case mode
        case allowlist
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The current OTP enforcement mode for the shared link.
    /// 
    /// * `none` - OTP enforcement is turned off. The shared link is accessible
    ///   without any one-time-passcode verification.
    /// * `open` - Any anonymous recipient can request a one-time-passcode to
    ///   any email address and access the shared link after verifying it.
    ///   Collaborators and registered Box users access the link without
    ///   being prompted.
    /// * `allowlist` - Anonymous recipients can request a one-time-passcode
    ///   only when they enter an email that matches an entry on the
    ///   `allowlist`.
    public let mode: String

    /// The list of email and domain entries that are permitted to access the
    /// shared link when `mode` is `allowlist`. Anonymous users whose
    /// email matches an entry can request and verify a one-time-passcode.
    /// 
    /// Because the entries carry recipient email addresses and the identity
    /// of the user who added them, this field is only returned to users
    /// with owner, co-owner, or editor access on the item. For viewer
    /// collaborators and below the field is omitted.
    /// 
    /// An allowlist contains at most 1000 entries, matching the limit
    /// enforced when setting the allowlist on a shared link.
    public let allowlist: [SharedLinkOtpAllowlistEntry]?

    /// Initializer for a FileSharedLinkOneTimePasscodeField.
    ///
    /// - Parameters:
    ///   - mode: The current OTP enforcement mode for the shared link.
    ///     
    ///     * `none` - OTP enforcement is turned off. The shared link is accessible
    ///       without any one-time-passcode verification.
    ///     * `open` - Any anonymous recipient can request a one-time-passcode to
    ///       any email address and access the shared link after verifying it.
    ///       Collaborators and registered Box users access the link without
    ///       being prompted.
    ///     * `allowlist` - Anonymous recipients can request a one-time-passcode
    ///       only when they enter an email that matches an entry on the
    ///       `allowlist`.
    ///   - allowlist: The list of email and domain entries that are permitted to access the
    ///     shared link when `mode` is `allowlist`. Anonymous users whose
    ///     email matches an entry can request and verify a one-time-passcode.
    ///     
    ///     Because the entries carry recipient email addresses and the identity
    ///     of the user who added them, this field is only returned to users
    ///     with owner, co-owner, or editor access on the item. For viewer
    ///     collaborators and below the field is omitted.
    ///     
    ///     An allowlist contains at most 1000 entries, matching the limit
    ///     enforced when setting the allowlist on a shared link.
    public init(mode: String, allowlist: [SharedLinkOtpAllowlistEntry]? = nil) {
        self.mode = mode
        self.allowlist = allowlist
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mode = try container.decode(String.self, forKey: .mode)
        allowlist = try container.decodeIfPresent([SharedLinkOtpAllowlistEntry].self, forKey: .allowlist)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mode, forKey: .mode)
        try container.encodeIfPresent(allowlist, forKey: .allowlist)
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
