import Foundation

/// A taxonomy `.csv` file to be used for the structured extraction. For your request to work, `fields` must also be provided.
public class AiTaxonomyFileReference: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case taxonomyKey = "taxonomy_key"
        case id
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The type of the taxonomy source.
    public let type: AiTaxonomyFileReferenceTypeField?

    /// The identifier for a taxonomy, which corresponds to the `taxonomy_key` of the taxonomy source.
    public let taxonomyKey: String?

    /// The ID of the taxonomy source. Required if the type is `file` and unsupported if the type is `taxonomy`.
    public let id: String?

    /// Initializer for a AiTaxonomyFileReference.
    ///
    /// - Parameters:
    ///   - type: The type of the taxonomy source.
    ///   - taxonomyKey: The identifier for a taxonomy, which corresponds to the `taxonomy_key` of the taxonomy source.
    ///   - id: The ID of the taxonomy source. Required if the type is `file` and unsupported if the type is `taxonomy`.
    public init(type: AiTaxonomyFileReferenceTypeField? = nil, taxonomyKey: String? = nil, id: String? = nil) {
        self.type = type
        self.taxonomyKey = taxonomyKey
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(AiTaxonomyFileReferenceTypeField.self, forKey: .type)
        taxonomyKey = try container.decodeIfPresent(String.self, forKey: .taxonomyKey)
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(taxonomyKey, forKey: .taxonomyKey)
        try container.encodeIfPresent(id, forKey: .id)
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
