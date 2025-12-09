import Foundation

/// The enterprise configuration for a given enterprise.
public class EnterpriseConfigurationV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case security
        case contentAndSharing = "content_and_sharing"
        case userSettings = "user_settings"
        case shield
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The identifier of the enterprise configuration which is the ID of the enterprise.
    public let id: String?

    /// The value will always be `enterprise_configuration`.
    public let type: EnterpriseConfigurationV2025R0TypeField?

    public let security: EnterpriseConfigurationSecurityV2025R0?

    public let contentAndSharing: EnterpriseConfigurationContentAndSharingV2025R0?

    public let userSettings: EnterpriseConfigurationUserSettingsV2025R0?

    public let shield: EnterpriseConfigurationShieldV2025R0?

    /// Initializer for a EnterpriseConfigurationV2025R0.
    ///
    /// - Parameters:
    ///   - id: The identifier of the enterprise configuration which is the ID of the enterprise.
    ///   - type: The value will always be `enterprise_configuration`.
    ///   - security: 
    ///   - contentAndSharing: 
    ///   - userSettings: 
    ///   - shield: 
    public init(id: String? = nil, type: EnterpriseConfigurationV2025R0TypeField? = nil, security: EnterpriseConfigurationSecurityV2025R0? = nil, contentAndSharing: EnterpriseConfigurationContentAndSharingV2025R0? = nil, userSettings: EnterpriseConfigurationUserSettingsV2025R0? = nil, shield: EnterpriseConfigurationShieldV2025R0? = nil) {
        self.id = id
        self.type = type
        self.security = security
        self.contentAndSharing = contentAndSharing
        self.userSettings = userSettings
        self.shield = shield
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(EnterpriseConfigurationV2025R0TypeField.self, forKey: .type)
        security = try container.decodeIfPresent(EnterpriseConfigurationSecurityV2025R0.self, forKey: .security)
        contentAndSharing = try container.decodeIfPresent(EnterpriseConfigurationContentAndSharingV2025R0.self, forKey: .contentAndSharing)
        userSettings = try container.decodeIfPresent(EnterpriseConfigurationUserSettingsV2025R0.self, forKey: .userSettings)
        shield = try container.decodeIfPresent(EnterpriseConfigurationShieldV2025R0.self, forKey: .shield)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(security, forKey: .security)
        try container.encodeIfPresent(contentAndSharing, forKey: .contentAndSharing)
        try container.encodeIfPresent(userSettings, forKey: .userSettings)
        try container.encodeIfPresent(shield, forKey: .shield)
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
