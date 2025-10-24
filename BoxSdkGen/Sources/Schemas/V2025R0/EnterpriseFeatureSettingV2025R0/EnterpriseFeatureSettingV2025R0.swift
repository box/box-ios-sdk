import Foundation

/// An enterprise feature setting.
public class EnterpriseFeatureSettingV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case feature
        case state
        case canConfigure = "can_configure"
        case isConfigured = "is_configured"
        case allowlist
        case denylist
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The identifier of the enterprise feature setting.
    @CodableTriState public private(set) var id: String?

    /// The feature.
    public let feature: EnterpriseFeatureSettingV2025R0FeatureField?

    /// The state of the feature.
    @CodableTriState public private(set) var state: String?

    /// Whether the feature can be configured.
    @CodableTriState public private(set) var canConfigure: Bool?

    /// Whether the feature is configured.
    @CodableTriState public private(set) var isConfigured: Bool?

    /// Enterprise feature setting is enabled for only this set of users and groups.
    @CodableTriState public private(set) var allowlist: [UserOrGroupReferenceV2025R0]?

    /// Enterprise feature setting is enabled for everyone except this set of users and groups.
    @CodableTriState public private(set) var denylist: [UserOrGroupReferenceV2025R0]?

    /// Initializer for a EnterpriseFeatureSettingV2025R0.
    ///
    /// - Parameters:
    ///   - id: The identifier of the enterprise feature setting.
    ///   - feature: The feature.
    ///   - state: The state of the feature.
    ///   - canConfigure: Whether the feature can be configured.
    ///   - isConfigured: Whether the feature is configured.
    ///   - allowlist: Enterprise feature setting is enabled for only this set of users and groups.
    ///   - denylist: Enterprise feature setting is enabled for everyone except this set of users and groups.
    public init(id: TriStateField<String> = nil, feature: EnterpriseFeatureSettingV2025R0FeatureField? = nil, state: TriStateField<String> = nil, canConfigure: TriStateField<Bool> = nil, isConfigured: TriStateField<Bool> = nil, allowlist: TriStateField<[UserOrGroupReferenceV2025R0]> = nil, denylist: TriStateField<[UserOrGroupReferenceV2025R0]> = nil) {
        self._id = CodableTriState(state: id)
        self.feature = feature
        self._state = CodableTriState(state: state)
        self._canConfigure = CodableTriState(state: canConfigure)
        self._isConfigured = CodableTriState(state: isConfigured)
        self._allowlist = CodableTriState(state: allowlist)
        self._denylist = CodableTriState(state: denylist)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        feature = try container.decodeIfPresent(EnterpriseFeatureSettingV2025R0FeatureField.self, forKey: .feature)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        canConfigure = try container.decodeIfPresent(Bool.self, forKey: .canConfigure)
        isConfigured = try container.decodeIfPresent(Bool.self, forKey: .isConfigured)
        allowlist = try container.decodeIfPresent([UserOrGroupReferenceV2025R0].self, forKey: .allowlist)
        denylist = try container.decodeIfPresent([UserOrGroupReferenceV2025R0].self, forKey: .denylist)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _id.state, forKey: .id)
        try container.encodeIfPresent(feature, forKey: .feature)
        try container.encode(field: _state.state, forKey: .state)
        try container.encode(field: _canConfigure.state, forKey: .canConfigure)
        try container.encode(field: _isConfigured.state, forKey: .isConfigured)
        try container.encode(field: _allowlist.state, forKey: .allowlist)
        try container.encode(field: _denylist.state, forKey: .denylist)
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
