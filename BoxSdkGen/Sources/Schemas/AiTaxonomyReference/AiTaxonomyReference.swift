import Foundation

/// A taxonomy source to be used for the structured extraction. For your request to work, `fields` must also be provided.
public class AiTaxonomyReference: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case taxonomyKey = "taxonomy_key"
        case namespace
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The type of the taxonomy source.
    public let type: AiTaxonomyReferenceTypeField?

    /// The identifier for a taxonomy, which corresponds to the `taxonomy_key` of the taxonomy source.
    public let taxonomyKey: String?

    /// The namespace of the taxonomy source.
    public let namespace: String?

    /// Initializer for a AiTaxonomyReference.
    ///
    /// - Parameters:
    ///   - type: The type of the taxonomy source.
    ///   - taxonomyKey: The identifier for a taxonomy, which corresponds to the `taxonomy_key` of the taxonomy source.
    ///   - namespace: The namespace of the taxonomy source.
    public init(type: AiTaxonomyReferenceTypeField? = nil, taxonomyKey: String? = nil, namespace: String? = nil) {
        self.type = type
        self.taxonomyKey = taxonomyKey
        self.namespace = namespace
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(AiTaxonomyReferenceTypeField.self, forKey: .type)
        taxonomyKey = try container.decodeIfPresent(String.self, forKey: .taxonomyKey)
        namespace = try container.decodeIfPresent(String.self, forKey: .namespace)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(taxonomyKey, forKey: .taxonomyKey)
        try container.encodeIfPresent(namespace, forKey: .namespace)
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
