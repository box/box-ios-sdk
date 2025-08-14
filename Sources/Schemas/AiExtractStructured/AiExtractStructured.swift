import Foundation

/// AI Extract Structured Request object.
public class AiExtractStructured: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case items
        case metadataTemplate = "metadata_template"
        case fields
        case aiAgent = "ai_agent"
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

    /// Initializer for a AiExtractStructured.
    ///
    /// - Parameters:
    ///   - items: The items to be processed by the LLM. Currently you can use files only.
    ///   - metadataTemplate: The metadata template containing the fields to extract.
    ///     For your request to work, you must provide either `metadata_template` or `fields`, but not both.
    ///   - fields: The fields to be extracted from the provided items.
    ///     For your request to work, you must provide either `metadata_template` or `fields`, but not both.
    ///   - aiAgent: 
    public init(items: [AiItemBase], metadataTemplate: AiExtractStructuredMetadataTemplateField? = nil, fields: [AiExtractStructuredFieldsField]? = nil, aiAgent: AiExtractStructuredAgent? = nil) {
        self.items = items
        self.metadataTemplate = metadataTemplate
        self.fields = fields
        self.aiAgent = aiAgent
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([AiItemBase].self, forKey: .items)
        metadataTemplate = try container.decodeIfPresent(AiExtractStructuredMetadataTemplateField.self, forKey: .metadataTemplate)
        fields = try container.decodeIfPresent([AiExtractStructuredFieldsField].self, forKey: .fields)
        aiAgent = try container.decodeIfPresent(AiExtractStructuredAgent.self, forKey: .aiAgent)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
        try container.encodeIfPresent(metadataTemplate, forKey: .metadataTemplate)
        try container.encodeIfPresent(fields, forKey: .fields)
        try container.encodeIfPresent(aiAgent, forKey: .aiAgent)
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
