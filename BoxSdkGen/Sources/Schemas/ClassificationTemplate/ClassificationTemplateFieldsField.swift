import Foundation

public class ClassificationTemplateFieldsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case options
        case type
        case key
        case displayName
        case hidden
    }

    /// The unique ID of the field.
    public let id: String

    /// A list of classifications available in this enterprise.
    public let options: [ClassificationTemplateFieldsOptionsField]

    /// The array item type.
    public let type: ClassificationTemplateFieldsTypeField

    /// Defines classifications 
    /// available in the enterprise.
    public let key: ClassificationTemplateFieldsKeyField

    /// `Classification`
    public let displayName: ClassificationTemplateFieldsDisplayNameField

    /// Classifications are always visible to web and mobile users.
    public let hidden: Bool?

    /// Initializer for a ClassificationTemplateFieldsField.
    ///
    /// - Parameters:
    ///   - id: The unique ID of the field.
    ///   - options: A list of classifications available in this enterprise.
    ///   - type: The array item type.
    ///   - key: Defines classifications 
    ///     available in the enterprise.
    ///   - displayName: `Classification`
    ///   - hidden: Classifications are always visible to web and mobile users.
    public init(id: String, options: [ClassificationTemplateFieldsOptionsField], type: ClassificationTemplateFieldsTypeField = ClassificationTemplateFieldsTypeField.enum_, key: ClassificationTemplateFieldsKeyField = ClassificationTemplateFieldsKeyField.boxSecurityClassificationKey, displayName: ClassificationTemplateFieldsDisplayNameField = ClassificationTemplateFieldsDisplayNameField.classification, hidden: Bool? = nil) {
        self.id = id
        self.options = options
        self.type = type
        self.key = key
        self.displayName = displayName
        self.hidden = hidden
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        options = try container.decode([ClassificationTemplateFieldsOptionsField].self, forKey: .options)
        type = try container.decode(ClassificationTemplateFieldsTypeField.self, forKey: .type)
        key = try container.decode(ClassificationTemplateFieldsKeyField.self, forKey: .key)
        displayName = try container.decode(ClassificationTemplateFieldsDisplayNameField.self, forKey: .displayName)
        hidden = try container.decodeIfPresent(Bool.self, forKey: .hidden)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(options, forKey: .options)
        try container.encode(type, forKey: .type)
        try container.encode(key, forKey: .key)
        try container.encode(displayName, forKey: .displayName)
        try container.encodeIfPresent(hidden, forKey: .hidden)
    }

}
