import Foundation

public class CreateClassificationTemplateRequestBodyFieldsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case options
        case type
        case key
        case displayName
        case hidden
    }

    /// The actual list of classifications that are present on
    /// this template.
    public let options: [CreateClassificationTemplateRequestBodyFieldsOptionsField]

    /// The type of the field
    /// that is always enum.
    public let type: CreateClassificationTemplateRequestBodyFieldsTypeField

    /// Defines classifications 
    /// available in the enterprise.
    public let key: CreateClassificationTemplateRequestBodyFieldsKeyField

    /// A display name for the classification.
    public let displayName: CreateClassificationTemplateRequestBodyFieldsDisplayNameField

    /// Determines if the classification
    /// template is
    /// hidden or available on
    /// web and mobile
    /// devices.
    public let hidden: Bool?

    /// Initializer for a CreateClassificationTemplateRequestBodyFieldsField.
    ///
    /// - Parameters:
    ///   - options: The actual list of classifications that are present on
    ///     this template.
    ///   - type: The type of the field
    ///     that is always enum.
    ///   - key: Defines classifications 
    ///     available in the enterprise.
    ///   - displayName: A display name for the classification.
    ///   - hidden: Determines if the classification
    ///     template is
    ///     hidden or available on
    ///     web and mobile
    ///     devices.
    public init(options: [CreateClassificationTemplateRequestBodyFieldsOptionsField], type: CreateClassificationTemplateRequestBodyFieldsTypeField = CreateClassificationTemplateRequestBodyFieldsTypeField.enum_, key: CreateClassificationTemplateRequestBodyFieldsKeyField = CreateClassificationTemplateRequestBodyFieldsKeyField.boxSecurityClassificationKey, displayName: CreateClassificationTemplateRequestBodyFieldsDisplayNameField = CreateClassificationTemplateRequestBodyFieldsDisplayNameField.classification, hidden: Bool? = nil) {
        self.options = options
        self.type = type
        self.key = key
        self.displayName = displayName
        self.hidden = hidden
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        options = try container.decode([CreateClassificationTemplateRequestBodyFieldsOptionsField].self, forKey: .options)
        type = try container.decode(CreateClassificationTemplateRequestBodyFieldsTypeField.self, forKey: .type)
        key = try container.decode(CreateClassificationTemplateRequestBodyFieldsKeyField.self, forKey: .key)
        displayName = try container.decode(CreateClassificationTemplateRequestBodyFieldsDisplayNameField.self, forKey: .displayName)
        hidden = try container.decodeIfPresent(Bool.self, forKey: .hidden)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(options, forKey: .options)
        try container.encode(type, forKey: .type)
        try container.encode(key, forKey: .key)
        try container.encode(displayName, forKey: .displayName)
        try container.encodeIfPresent(hidden, forKey: .hidden)
    }

}
