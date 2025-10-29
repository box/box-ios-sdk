import Foundation

/// External collaboration security settings.
public class ExternalCollabSecuritySettingsV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case denylistDomains = "denylist_domains"
        case denylistEmails = "denylist_emails"
        case allowlistDomains = "allowlist_domains"
        case allowlistEmails = "allowlist_emails"
        case state
        case scheduledStatus = "scheduled_status"
        case scheduledAt = "scheduled_at"
        case factorTypeSettings = "factor_type_settings"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// List of domains that are not allowed for external collaboration. Applies if state is `denylist`.
    public let denylistDomains: [String]?

    /// List of email addresses that are not allowed for external collaboration. Applies if state is `denylist`.
    public let denylistEmails: [String]?

    /// List of domains that are allowed for external collaboration. Applies if state is `allowlist`.
    public let allowlistDomains: [String]?

    /// List of email addresses that are allowed for external collaboration. Applies if state is `allowlist`.
    public let allowlistEmails: [String]?

    /// The state of the external collaboration security settings. Possible values include `enabled`, `disabled`, `allowlist`, and `denylist`.
    @CodableTriState public private(set) var state: String?

    /// The status of the scheduling to apply external collaboration security settings. Possible values include `in_progress`, `scheduled`, `completed`, `failed`, and `scheduled_immediate`.
    @CodableTriState public private(set) var scheduledStatus: String?

    /// Scheduled at.
    @CodableTriState public private(set) var scheduledAt: Date?

    /// Factor type for the external collaborators authentication. Possible values include `totp`, `any`, or `unknown`.
    @CodableTriState public private(set) var factorTypeSettings: String?

    /// Initializer for a ExternalCollabSecuritySettingsV2025R0.
    ///
    /// - Parameters:
    ///   - denylistDomains: List of domains that are not allowed for external collaboration. Applies if state is `denylist`.
    ///   - denylistEmails: List of email addresses that are not allowed for external collaboration. Applies if state is `denylist`.
    ///   - allowlistDomains: List of domains that are allowed for external collaboration. Applies if state is `allowlist`.
    ///   - allowlistEmails: List of email addresses that are allowed for external collaboration. Applies if state is `allowlist`.
    ///   - state: The state of the external collaboration security settings. Possible values include `enabled`, `disabled`, `allowlist`, and `denylist`.
    ///   - scheduledStatus: The status of the scheduling to apply external collaboration security settings. Possible values include `in_progress`, `scheduled`, `completed`, `failed`, and `scheduled_immediate`.
    ///   - scheduledAt: Scheduled at.
    ///   - factorTypeSettings: Factor type for the external collaborators authentication. Possible values include `totp`, `any`, or `unknown`.
    public init(denylistDomains: [String]? = nil, denylistEmails: [String]? = nil, allowlistDomains: [String]? = nil, allowlistEmails: [String]? = nil, state: TriStateField<String> = nil, scheduledStatus: TriStateField<String> = nil, scheduledAt: TriStateField<Date> = nil, factorTypeSettings: TriStateField<String> = nil) {
        self.denylistDomains = denylistDomains
        self.denylistEmails = denylistEmails
        self.allowlistDomains = allowlistDomains
        self.allowlistEmails = allowlistEmails
        self._state = CodableTriState(state: state)
        self._scheduledStatus = CodableTriState(state: scheduledStatus)
        self._scheduledAt = CodableTriState(state: scheduledAt)
        self._factorTypeSettings = CodableTriState(state: factorTypeSettings)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        denylistDomains = try container.decodeIfPresent([String].self, forKey: .denylistDomains)
        denylistEmails = try container.decodeIfPresent([String].self, forKey: .denylistEmails)
        allowlistDomains = try container.decodeIfPresent([String].self, forKey: .allowlistDomains)
        allowlistEmails = try container.decodeIfPresent([String].self, forKey: .allowlistEmails)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        scheduledStatus = try container.decodeIfPresent(String.self, forKey: .scheduledStatus)
        scheduledAt = try container.decodeDateTimeIfPresent(forKey: .scheduledAt)
        factorTypeSettings = try container.decodeIfPresent(String.self, forKey: .factorTypeSettings)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(denylistDomains, forKey: .denylistDomains)
        try container.encodeIfPresent(denylistEmails, forKey: .denylistEmails)
        try container.encodeIfPresent(allowlistDomains, forKey: .allowlistDomains)
        try container.encodeIfPresent(allowlistEmails, forKey: .allowlistEmails)
        try container.encode(field: _state.state, forKey: .state)
        try container.encode(field: _scheduledStatus.state, forKey: .scheduledStatus)
        try container.encodeDateTime(field: _scheduledAt.state, forKey: .scheduledAt)
        try container.encode(field: _factorTypeSettings.state, forKey: .factorTypeSettings)
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
