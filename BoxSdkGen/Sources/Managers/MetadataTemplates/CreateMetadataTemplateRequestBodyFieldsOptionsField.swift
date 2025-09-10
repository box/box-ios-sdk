import Foundation

public class CreateMetadataTemplateRequestBodyFieldsOptionsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case key
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The text value of the option. This represents both the display name of the
    /// option and the internal key used when updating templates.
    public let key: String

    /// Initializer for a CreateMetadataTemplateRequestBodyFieldsOptionsField.
    ///
    /// - Parameters:
    ///   - key: The text value of the option. This represents both the display name of the
    ///     option and the internal key used when updating templates.
    public init(key: String) {
        self.key = key
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
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
