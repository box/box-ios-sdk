import Foundation

/// An enterprise feature settings item.
public class EnterpriseFeatureSettingsItemV2025R0: EnterpriseConfigurationItemV2025R0 {
    private enum CodingKeys: String, CodingKey {
        case value
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    public let value: EnterpriseFeatureSettingV2025R0?

    /// Initializer for a EnterpriseFeatureSettingsItemV2025R0.
    ///
    /// - Parameters:
    ///   - isUsed: Indicates whether a configuration is used for a given enterprise.
    ///   - value: 
    public init(isUsed: Bool? = nil, value: EnterpriseFeatureSettingV2025R0? = nil) {
        self.value = value

        super.init(isUsed: isUsed)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decodeIfPresent(EnterpriseFeatureSettingV2025R0.self, forKey: .value)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(value, forKey: .value)
        try super.encode(to: encoder)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    override func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    override func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
