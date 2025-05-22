import Foundation

/// AI Extract Structured Request object.
public class AiExtractStructured: Codable {
    private enum CodingKeys: String, CodingKey {
        case items
        case metadataTemplate = "metadata_template"
        case fields
        case aiAgent = "ai_agent"
    }

    /// The items to be processed by the LLM. Currently you can use files only.
    public let items: [AiItemBase]

    /// The metadata template containing the fields to extract.
    /// For your request to work, you must provide either `metadata_template` or `fields`, but not both.
    public let metadataTemplate: AiExtractStructuredMetadataTemplateField?

    /// The fields to be extracted from the provided items.
    /// For your request to work, you must provide either `metadata_template` or `fields`, but not both.
    public let fields: [AiExtractStructuredFieldsField]?

    public let aiAgent: AiAgentExtractStructuredOrAiAgentReference?

    /// Initializer for a AiExtractStructured.
    ///
    /// - Parameters:
    ///   - items: The items to be processed by the LLM. Currently you can use files only.
    ///   - metadataTemplate: The metadata template containing the fields to extract.
    ///     For your request to work, you must provide either `metadata_template` or `fields`, but not both.
    ///   - fields: The fields to be extracted from the provided items.
    ///     For your request to work, you must provide either `metadata_template` or `fields`, but not both.
    ///   - aiAgent: 
    public init(items: [AiItemBase], metadataTemplate: AiExtractStructuredMetadataTemplateField? = nil, fields: [AiExtractStructuredFieldsField]? = nil, aiAgent: AiAgentExtractStructuredOrAiAgentReference? = nil) {
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
        aiAgent = try container.decodeIfPresent(AiAgentExtractStructuredOrAiAgentReference.self, forKey: .aiAgent)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
        try container.encodeIfPresent(metadataTemplate, forKey: .metadataTemplate)
        try container.encodeIfPresent(fields, forKey: .fields)
        try container.encodeIfPresent(aiAgent, forKey: .aiAgent)
    }

}
