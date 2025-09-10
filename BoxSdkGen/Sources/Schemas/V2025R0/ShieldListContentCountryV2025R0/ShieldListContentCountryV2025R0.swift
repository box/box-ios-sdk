import Foundation

/// Representation of content of a Shield List that contains countries data.
public class ShieldListContentCountryV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case countryCodes = "country_codes"
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// List of country codes values.
    public let countryCodes: [String]

    /// The type of content in the shield list.
    public let type: ShieldListContentCountryV2025R0TypeField

    /// Initializer for a ShieldListContentCountryV2025R0.
    ///
    /// - Parameters:
    ///   - countryCodes: List of country codes values.
    ///   - type: The type of content in the shield list.
    public init(countryCodes: [String], type: ShieldListContentCountryV2025R0TypeField = ShieldListContentCountryV2025R0TypeField.country) {
        self.countryCodes = countryCodes
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        countryCodes = try container.decode([String].self, forKey: .countryCodes)
        type = try container.decode(ShieldListContentCountryV2025R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(countryCodes, forKey: .countryCodes)
        try container.encode(type, forKey: .type)
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
