import Foundation

public class UpdateAllSkillCardsOnFileRequestBodyUsageField: Codable {
    private enum CodingKeys: String, CodingKey {
        case unit
        case value
    }

    /// `file`
    public let unit: String?

    /// `1`
    public let value: Double?

    /// Initializer for a UpdateAllSkillCardsOnFileRequestBodyUsageField.
    ///
    /// - Parameters:
    ///   - unit: `file`
    ///   - value: `1`
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

}
