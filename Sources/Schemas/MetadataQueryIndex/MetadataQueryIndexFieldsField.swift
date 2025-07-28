import Foundation

public class MetadataQueryIndexFieldsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case key
        case sortDirection = "sort_direction"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The metadata template field key.
    public let key: String?

    /// The sort direction of the field.
    public let sortDirection: MetadataQueryIndexFieldsSortDirectionField?

    /// Initializer for a MetadataQueryIndexFieldsField.
    ///
    /// - Parameters:
    ///   - key: The metadata template field key.
    ///   - sortDirection: The sort direction of the field.
    public init(key: String? = nil, sortDirection: MetadataQueryIndexFieldsSortDirectionField? = nil) {
        self.key = key
        self.sortDirection = sortDirection
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decodeIfPresent(String.self, forKey: .key)
        sortDirection = try container.decodeIfPresent(MetadataQueryIndexFieldsSortDirectionField.self, forKey: .sortDirection)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(key, forKey: .key)
        try container.encodeIfPresent(sortDirection, forKey: .sortDirection)
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
