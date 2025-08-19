import Foundation

public class UpdateAllSkillCardsOnFileRequestBodyUsageField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case unit
        case value
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The value will always be `file`.
    public let unit: String?

    /// Number of resources affected.
    public let value: Double?

    /// Initializer for a UpdateAllSkillCardsOnFileRequestBodyUsageField.
    ///
    /// - Parameters:
    ///   - unit: The value will always be `file`.
    ///   - value: Number of resources affected.
    public init(unit: String? = nil, value: Double? = nil) {
        self.unit = unit
        self.value = value
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        unit = try container.decodeIfPresent(String.self, forKey: .unit)
        value = try container.decodeIfPresent(Double.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(unit, forKey: .unit)
        try container.encodeIfPresent(value, forKey: .value)
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
