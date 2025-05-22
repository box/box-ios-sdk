import Foundation

public class CreateMetadataTemplateRequestBodyFieldsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case key
        case displayName
        case description
        case hidden
        case options
    }

    /// The type of field. The basic fields are a `string` field for text, a
    /// `float` field for numbers, and a `date` fields to present the user with a
    /// date-time picker.
    /// 
    /// Additionally, metadata templates support an `enum` field for a basic list
    /// of items, and ` multiSelect` field for a similar list of items where the
    /// user can select more than one value.
    public let type: CreateMetadataTemplateRequestBodyFieldsTypeField

    /// A unique identifier for the field. The identifier must
    /// be unique within the template to which it belongs.
    public let key: String

    /// The display name of the field as it is shown to the user in the web and
    /// mobile apps.
    public let displayName: String

    /// A description of the field. This is not shown to the user.
    public let description: String?

    /// Whether this field is hidden in the UI for the user and can only be set
    /// through the API instead.
    public let hidden: Bool?

    /// A list of options for this field. This is used in combination with the
    /// `enum` and `multiSelect` field types.
    public let options: [CreateMetadataTemplateRequestBodyFieldsOptionsField]?

    /// Initializer for a CreateMetadataTemplateRequestBodyFieldsField.
    ///
    /// - Parameters:
    ///   - type: The type of field. The basic fields are a `string` field for text, a
    ///     `float` field for numbers, and a `date` fields to present the user with a
    ///     date-time picker.
    ///     
    ///     Additionally, metadata templates support an `enum` field for a basic list
    ///     of items, and ` multiSelect` field for a similar list of items where the
    ///     user can select more than one value.
    ///   - key: A unique identifier for the field. The identifier must
    ///     be unique within the template to which it belongs.
    ///   - displayName: The display name of the field as it is shown to the user in the web and
    ///     mobile apps.
    ///   - description: A description of the field. This is not shown to the user.
    ///   - hidden: Whether this field is hidden in the UI for the user and can only be set
    ///     through the API instead.
    ///   - options: A list of options for this field. This is used in combination with the
    ///     `enum` and `multiSelect` field types.
    public init(type: CreateMetadataTemplateRequestBodyFieldsTypeField, key: String, displayName: String, description: String? = nil, hidden: Bool? = nil, options: [CreateMetadataTemplateRequestBodyFieldsOptionsField]? = nil) {
        self.type = type
        self.key = key
        self.displayName = displayName
        self.description = description
        self.hidden = hidden
        self.options = options
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(CreateMetadataTemplateRequestBodyFieldsTypeField.self, forKey: .type)
        key = try container.decode(String.self, forKey: .key)
        displayName = try container.decode(String.self, forKey: .displayName)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        hidden = try container.decodeIfPresent(Bool.self, forKey: .hidden)
        options = try container.decodeIfPresent([CreateMetadataTemplateRequestBodyFieldsOptionsField].self, forKey: .options)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(key, forKey: .key)
        try container.encode(displayName, forKey: .displayName)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(hidden, forKey: .hidden)
        try container.encodeIfPresent(options, forKey: .options)
    }

}
