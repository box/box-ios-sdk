import Foundation

/// An enterprise configuration item with a integer type value.
public class EnterpriseConfigurationItemIntegerV2025R0: EnterpriseConfigurationItemV2025R0 {
    private enum CodingKeys: String, CodingKey {
        case value
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// The value of the enterprise configuration as an integer.
    @CodableTriState public private(set) var value: Int64?

    /// Initializer for a EnterpriseConfigurationItemIntegerV2025R0.
    ///
    /// - Parameters:
    ///   - isUsed: Indicates whether a configuration is used for a given enterprise.
    ///   - value: The value of the enterprise configuration as an integer.
    public init(isUsed: Bool? = nil, value: TriStateField<Int64> = nil) {
        self._value = CodableTriState(state: value)

        super.init(isUsed: isUsed)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decodeIfPresent(Int64.self, forKey: .value)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _value.state, forKey: .value)
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
