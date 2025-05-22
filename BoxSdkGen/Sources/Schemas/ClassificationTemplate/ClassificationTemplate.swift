import Foundation

/// A metadata template that holds the security classifications
/// defined by an enterprise.
public class ClassificationTemplate: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case scope
        case fields
        case type
        case templateKey
        case displayName
        case hidden
        case copyInstanceOnItemCopy
    }

    /// The ID of the classification template.
    public let id: String

    /// The scope of the classification template. This is in the format
    /// `enterprise_{id}` where the `id` is the enterprise ID.
    public let scope: String

    /// A list of fields for this classification template. This includes
    /// only one field, the `Box__Security__Classification__Key`, which defines
    /// the different classifications available in this enterprise.
    public let fields: [ClassificationTemplateFieldsField]

    /// `metadata_template`
    public let type: ClassificationTemplateTypeField

    /// `securityClassification-6VMVochwUWo`
    public let templateKey: ClassificationTemplateTemplateKeyField

    /// The name of this template as shown in web and mobile interfaces.
    public let displayName: ClassificationTemplateDisplayNameField

    /// Determines if the
    /// template is always available in web and mobile interfaces.
    public let hidden: Bool?

    /// Determines if 
    /// classifications are
    /// copied along when the file or folder is
    /// copied.
    public let copyInstanceOnItemCopy: Bool?

    /// Initializer for a ClassificationTemplate.
    ///
    /// - Parameters:
    ///   - id: The ID of the classification template.
    ///   - scope: The scope of the classification template. This is in the format
    ///     `enterprise_{id}` where the `id` is the enterprise ID.
    ///   - fields: A list of fields for this classification template. This includes
    ///     only one field, the `Box__Security__Classification__Key`, which defines
    ///     the different classifications available in this enterprise.
    ///   - type: `metadata_template`
    ///   - templateKey: `securityClassification-6VMVochwUWo`
    ///   - displayName: The name of this template as shown in web and mobile interfaces.
    ///   - hidden: Determines if the
    ///     template is always available in web and mobile interfaces.
    ///   - copyInstanceOnItemCopy: Determines if 
    ///     classifications are
    ///     copied along when the file or folder is
    ///     copied.
    public init(id: String, scope: String, fields: [ClassificationTemplateFieldsField], type: ClassificationTemplateTypeField = ClassificationTemplateTypeField.metadataTemplate, templateKey: ClassificationTemplateTemplateKeyField = ClassificationTemplateTemplateKeyField.securityClassification6VmVochwUWo, displayName: ClassificationTemplateDisplayNameField = ClassificationTemplateDisplayNameField.classification, hidden: Bool? = nil, copyInstanceOnItemCopy: Bool? = nil) {
        self.id = id
        self.scope = scope
        self.fields = fields
        self.type = type
        self.templateKey = templateKey
        self.displayName = displayName
        self.hidden = hidden
        self.copyInstanceOnItemCopy = copyInstanceOnItemCopy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        scope = try container.decode(String.self, forKey: .scope)
        fields = try container.decode([ClassificationTemplateFieldsField].self, forKey: .fields)
        type = try container.decode(ClassificationTemplateTypeField.self, forKey: .type)
        templateKey = try container.decode(ClassificationTemplateTemplateKeyField.self, forKey: .templateKey)
        displayName = try container.decode(ClassificationTemplateDisplayNameField.self, forKey: .displayName)
        hidden = try container.decodeIfPresent(Bool.self, forKey: .hidden)
        copyInstanceOnItemCopy = try container.decodeIfPresent(Bool.self, forKey: .copyInstanceOnItemCopy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(scope, forKey: .scope)
        try container.encode(fields, forKey: .fields)
        try container.encode(type, forKey: .type)
        try container.encode(templateKey, forKey: .templateKey)
        try container.encode(displayName, forKey: .displayName)
        try container.encodeIfPresent(hidden, forKey: .hidden)
        try container.encodeIfPresent(copyInstanceOnItemCopy, forKey: .copyInstanceOnItemCopy)
    }

}
