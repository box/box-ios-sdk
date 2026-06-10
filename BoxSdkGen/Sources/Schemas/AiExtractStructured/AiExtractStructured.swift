import Foundation

/// AI Extract Structured Request object.
public class AiExtractStructured: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case items
        case metadataTemplate = "metadata_template"
        case fields
        case aiAgent = "ai_agent"
        case includeConfidenceScore = "include_confidence_score"
        case includeReference = "include_reference"
        case taxonomySources = "taxonomy_sources"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The items to be processed by the LLM. Currently you can use files only.
    public let items: [AiItemBase]

    /// The metadata template containing the fields to extract.
    /// For your request to work, you must provide either `metadata_template` or `fields`, but not both.
    public let metadataTemplate: AiExtractStructuredMetadataTemplateField?

    /// The fields to be extracted from the provided items.
    /// For your request to work, you must provide either `metadata_template` or `fields`, but not both.
    public let fields: [AiExtractStructuredFieldsField]?

    public let aiAgent: AiExtractStructuredAgent?

    /// A flag to indicate whether confidence scores for every extracted field should be returned.
    public let includeConfidenceScore: Bool?

    /// A flag to indicate whether references for every extracted field should be returned.
    public let includeReference: Bool?

    /// The taxonomy sources to be used for the structured extraction. They can either be an existing file or a taxonomy.
    /// For your request to work, `fields` must also be provided. `taxonomy_sources` is not supported with `metadata_template`.
    public let taxonomySources: [AiTaxonomySource]?

    /// Initializer for a AiExtractStructured.
    ///
    /// - Parameters:
    ///   - items: The items to be processed by the LLM. Currently you can use files only.
    ///   - metadataTemplate: The metadata template containing the fields to extract.
    ///     For your request to work, you must provide either `metadata_template` or `fields`, but not both.
    ///   - fields: The fields to be extracted from the provided items.
    ///     For your request to work, you must provide either `metadata_template` or `fields`, but not both.
    ///   - aiAgent: 
    ///   - includeConfidenceScore: A flag to indicate whether confidence scores for every extracted field should be returned.
    ///   - includeReference: A flag to indicate whether references for every extracted field should be returned.
    ///   - taxonomySources: The taxonomy sources to be used for the structured extraction. They can either be an existing file or a taxonomy.
    ///     For your request to work, `fields` must also be provided. `taxonomy_sources` is not supported with `metadata_template`.
    public init(items: [AiItemBase], metadataTemplate: AiExtractStructuredMetadataTemplateField? = nil, fields: [AiExtractStructuredFieldsField]? = nil, aiAgent: AiExtractStructuredAgent? = nil, includeConfidenceScore: Bool? = nil, includeReference: Bool? = nil, taxonomySources: [AiTaxonomySource]? = nil) {
        self.items = items
        self.metadataTemplate = metadataTemplate
        self.fields = fields
        self.aiAgent = aiAgent
        self.includeConfidenceScore = includeConfidenceScore
        self.includeReference = includeReference
        self.taxonomySources = taxonomySources
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([AiItemBase].self, forKey: .items)
        metadataTemplate = try container.decodeIfPresent(AiExtractStructuredMetadataTemplateField.self, forKey: .metadataTemplate)
        fields = try container.decodeIfPresent([AiExtractStructuredFieldsField].self, forKey: .fields)
        aiAgent = try container.decodeIfPresent(AiExtractStructuredAgent.self, forKey: .aiAgent)
        includeConfidenceScore = try container.decodeIfPresent(Bool.self, forKey: .includeConfidenceScore)
        includeReference = try container.decodeIfPresent(Bool.self, forKey: .includeReference)
        taxonomySources = try container.decodeIfPresent([AiTaxonomySource].self, forKey: .taxonomySources)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
        try container.encodeIfPresent(metadataTemplate, forKey: .metadataTemplate)
        try container.encodeIfPresent(fields, forKey: .fields)
        try container.encodeIfPresent(aiAgent, forKey: .aiAgent)
        try container.encodeIfPresent(includeConfidenceScore, forKey: .includeConfidenceScore)
        try container.encodeIfPresent(includeReference, forKey: .includeReference)
        try container.encodeIfPresent(taxonomySources, forKey: .taxonomySources)
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
