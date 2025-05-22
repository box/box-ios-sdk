import Foundation

/// A template for metadata that can be applied to files and folders
public class MetadataTemplate: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case scope
        case templateKey
        case displayName
        case hidden
        case fields
        case copyInstanceOnItemCopy
    }

    /// The ID of the metadata template.
    public let id: String

    /// `metadata_template`
    public let type: MetadataTemplateTypeField

    /// The scope of the metadata template can either be `global` or
    /// `enterprise_*`. The `global` scope is used for templates that are
    /// available to any Box enterprise. The `enterprise_*` scope represents
    /// templates that have been created within a specific enterprise, where `*`
    /// will be the ID of that enterprise.
    public let scope: String?

    /// A unique identifier for the template. This identifier is unique across
    /// the `scope` of the enterprise to which the metadata template is being
    /// applied, yet is not necessarily unique across different enterprises.
    public let templateKey: String?

    /// The display name of the template. This can be seen in the Box web app
    /// and mobile apps.
    public let displayName: String?

    /// Defines if this template is visible in the Box web app UI, or if
    /// it is purely intended for usage through the API.
    public let hidden: Bool?

    /// An ordered list of template fields which are part of the template. Each
    /// field can be a regular text field, date field, number field, as well as a
    /// single or multi-select list.
    public let fields: [MetadataTemplateFieldsField]?

    /// Whether or not to include the metadata when a file or folder is copied.
    public let copyInstanceOnItemCopy: Bool?

    /// Initializer for a MetadataTemplate.
    ///
    /// - Parameters:
    ///   - id: The ID of the metadata template.
    ///   - type: `metadata_template`
    ///   - scope: The scope of the metadata template can either be `global` or
    ///     `enterprise_*`. The `global` scope is used for templates that are
    ///     available to any Box enterprise. The `enterprise_*` scope represents
    ///     templates that have been created within a specific enterprise, where `*`
    ///     will be the ID of that enterprise.
    ///   - templateKey: A unique identifier for the template. This identifier is unique across
    ///     the `scope` of the enterprise to which the metadata template is being
    ///     applied, yet is not necessarily unique across different enterprises.
    ///   - displayName: The display name of the template. This can be seen in the Box web app
    ///     and mobile apps.
    ///   - hidden: Defines if this template is visible in the Box web app UI, or if
    ///     it is purely intended for usage through the API.
    ///   - fields: An ordered list of template fields which are part of the template. Each
    ///     field can be a regular text field, date field, number field, as well as a
    ///     single or multi-select list.
    ///   - copyInstanceOnItemCopy: Whether or not to include the metadata when a file or folder is copied.
    public init(id: String, type: MetadataTemplateTypeField = MetadataTemplateTypeField.metadataTemplate, scope: String? = nil, templateKey: String? = nil, displayName: String? = nil, hidden: Bool? = nil, fields: [MetadataTemplateFieldsField]? = nil, copyInstanceOnItemCopy: Bool? = nil) {
        self.id = id
        self.type = type
        self.scope = scope
        self.templateKey = templateKey
        self.displayName = displayName
        self.hidden = hidden
        self.fields = fields
        self.copyInstanceOnItemCopy = copyInstanceOnItemCopy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(MetadataTemplateTypeField.self, forKey: .type)
        scope = try container.decodeIfPresent(String.self, forKey: .scope)
        templateKey = try container.decodeIfPresent(String.self, forKey: .templateKey)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        hidden = try container.decodeIfPresent(Bool.self, forKey: .hidden)
        fields = try container.decodeIfPresent([MetadataTemplateFieldsField].self, forKey: .fields)
        copyInstanceOnItemCopy = try container.decodeIfPresent(Bool.self, forKey: .copyInstanceOnItemCopy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(scope, forKey: .scope)
        try container.encodeIfPresent(templateKey, forKey: .templateKey)
        try container.encodeIfPresent(displayName, forKey: .displayName)
        try container.encodeIfPresent(hidden, forKey: .hidden)
        try container.encodeIfPresent(fields, forKey: .fields)
        try container.encodeIfPresent(copyInstanceOnItemCopy, forKey: .copyInstanceOnItemCopy)
    }

}
