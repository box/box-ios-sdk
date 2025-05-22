import Foundation

public class AiExtractStructuredMetadataTemplateField: Codable {
    private enum CodingKeys: String, CodingKey {
        case templateKey = "template_key"
        case type
        case scope
    }

    /// The name of the metadata template.
    public let templateKey: String?

    /// Value is always `metadata_template`.
    public let type: AiExtractStructuredMetadataTemplateTypeField?

    /// The scope of the metadata template that can either be global or
    /// enterprise.
    /// * The **global** scope is used for templates that are
    /// available to any Box enterprise.
    /// * The **enterprise** scope represents templates created within a specific enterprise,
    ///   containing the ID of that enterprise.
    public let scope: String?

    /// Initializer for a AiExtractStructuredMetadataTemplateField.
    ///
    /// - Parameters:
    ///   - templateKey: The name of the metadata template.
    ///   - type: Value is always `metadata_template`.
    ///   - scope: The scope of the metadata template that can either be global or
    ///     enterprise.
    ///     * The **global** scope is used for templates that are
    ///     available to any Box enterprise.
    ///     * The **enterprise** scope represents templates created within a specific enterprise,
    ///       containing the ID of that enterprise.
    public init(templateKey: String? = nil, type: AiExtractStructuredMetadataTemplateTypeField? = nil, scope: String? = nil) {
        self.templateKey = templateKey
        self.type = type
        self.scope = scope
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        templateKey = try container.decodeIfPresent(String.self, forKey: .templateKey)
        type = try container.decodeIfPresent(AiExtractStructuredMetadataTemplateTypeField.self, forKey: .type)
        scope = try container.decodeIfPresent(String.self, forKey: .scope)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(templateKey, forKey: .templateKey)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(scope, forKey: .scope)
    }

}
