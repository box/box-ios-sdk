import Foundation

public class EnterpriseConfigurationSecurityV2025R0EnforcedMfaFrequencyField: EnterpriseConfigurationItemV2025R0 {
    private enum CodingKeys: String, CodingKey {
        case value
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    public let value: EnterpriseConfigurationSecurityV2025R0EnforcedMfaFrequencyFieldValueField?

    /// Initializer for a EnterpriseConfigurationSecurityV2025R0EnforcedMfaFrequencyField.
    ///
    /// - Parameters:
    ///   - isUsed: Indicates whether a configuration is used for a given enterprise.
    ///   - value: 
    public init(isUsed: Bool? = nil, value: EnterpriseConfigurationSecurityV2025R0EnforcedMfaFrequencyFieldValueField? = nil) {
        self.value = value

        super.init(isUsed: isUsed)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decodeIfPresent(EnterpriseConfigurationSecurityV2025R0EnforcedMfaFrequencyFieldValueField.self, forKey: .value)

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
