import Foundation

/// The enterprise configuration for the shield category.
public class EnterpriseConfigurationShieldV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case shieldRules = "shield_rules"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The shield rules configuration for the enterprise.
    public let shieldRules: [ShieldRuleItemV2025R0]?

    /// Initializer for a EnterpriseConfigurationShieldV2025R0.
    ///
    /// - Parameters:
    ///   - shieldRules: The shield rules configuration for the enterprise.
    public init(shieldRules: [ShieldRuleItemV2025R0]? = nil) {
        self.shieldRules = shieldRules
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shieldRules = try container.decodeIfPresent([ShieldRuleItemV2025R0].self, forKey: .shieldRules)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(shieldRules, forKey: .shieldRules)
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
