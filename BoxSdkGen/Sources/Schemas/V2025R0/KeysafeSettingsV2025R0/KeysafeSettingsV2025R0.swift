import Foundation

/// The KeySafe settings.
public class KeysafeSettingsV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case keysafeEnabled = "keysafe_enabled"
        case cloudProvider = "cloud_provider"
        case keyId = "key_id"
        case accountId = "account_id"
        case locationId = "location_id"
        case projectId = "project_id"
        case keyringId = "keyring_id"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Whether KeySafe addon is enabled for the enterprise.
    public let keysafeEnabled: Bool?

    /// The cloud provider.
    @CodableTriState public private(set) var cloudProvider: String?

    /// The key ID.
    @CodableTriState public private(set) var keyId: String?

    /// The account ID.
    @CodableTriState public private(set) var accountId: String?

    /// The location ID.
    @CodableTriState public private(set) var locationId: String?

    /// The project ID.
    @CodableTriState public private(set) var projectId: String?

    /// The key ring ID.
    @CodableTriState public private(set) var keyringId: String?

    /// Initializer for a KeysafeSettingsV2025R0.
    ///
    /// - Parameters:
    ///   - keysafeEnabled: Whether KeySafe addon is enabled for the enterprise.
    ///   - cloudProvider: The cloud provider.
    ///   - keyId: The key ID.
    ///   - accountId: The account ID.
    ///   - locationId: The location ID.
    ///   - projectId: The project ID.
    ///   - keyringId: The key ring ID.
    public init(keysafeEnabled: Bool? = nil, cloudProvider: TriStateField<String> = nil, keyId: TriStateField<String> = nil, accountId: TriStateField<String> = nil, locationId: TriStateField<String> = nil, projectId: TriStateField<String> = nil, keyringId: TriStateField<String> = nil) {
        self.keysafeEnabled = keysafeEnabled
        self._cloudProvider = CodableTriState(state: cloudProvider)
        self._keyId = CodableTriState(state: keyId)
        self._accountId = CodableTriState(state: accountId)
        self._locationId = CodableTriState(state: locationId)
        self._projectId = CodableTriState(state: projectId)
        self._keyringId = CodableTriState(state: keyringId)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        keysafeEnabled = try container.decodeIfPresent(Bool.self, forKey: .keysafeEnabled)
        cloudProvider = try container.decodeIfPresent(String.self, forKey: .cloudProvider)
        keyId = try container.decodeIfPresent(String.self, forKey: .keyId)
        accountId = try container.decodeIfPresent(String.self, forKey: .accountId)
        locationId = try container.decodeIfPresent(String.self, forKey: .locationId)
        projectId = try container.decodeIfPresent(String.self, forKey: .projectId)
        keyringId = try container.decodeIfPresent(String.self, forKey: .keyringId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(keysafeEnabled, forKey: .keysafeEnabled)
        try container.encode(field: _cloudProvider.state, forKey: .cloudProvider)
        try container.encode(field: _keyId.state, forKey: .keyId)
        try container.encode(field: _accountId.state, forKey: .accountId)
        try container.encode(field: _locationId.state, forKey: .locationId)
        try container.encode(field: _projectId.state, forKey: .projectId)
        try container.encode(field: _keyringId.state, forKey: .keyringId)
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
