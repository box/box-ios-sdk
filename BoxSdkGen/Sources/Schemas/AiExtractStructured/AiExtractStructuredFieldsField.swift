import Foundation

public class AiExtractStructuredFieldsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case key
        case description
        case displayName
        case prompt
        case type
        case options
    }

    /// A unique identifier for the field.
    public let key: String

    /// A description of the field.
    public let description: String?

    /// The display name of the field.
    public let displayName: String?

    /// The context about the key that may include how to find and format it.
    public let prompt: String?

    /// The type of the field. It include but is not limited to string, float, date, enum, and multiSelect.
    public let type: String?

    /// A list of options for this field. This is most often used in combination with the enum and multiSelect field types.
    public let options: [AiExtractStructuredFieldsOptionsField]?

    /// Initializer for a AiExtractStructuredFieldsField.
    ///
    /// - Parameters:
    ///   - key: A unique identifier for the field.
    ///   - description: A description of the field.
    ///   - displayName: The display name of the field.
    ///   - prompt: The context about the key that may include how to find and format it.
    ///   - type: The type of the field. It include but is not limited to string, float, date, enum, and multiSelect.
    ///   - options: A list of options for this field. This is most often used in combination with the enum and multiSelect field types.
    public init(key: String, description: String? = nil, displayName: String? = nil, prompt: String? = nil, type: String? = nil, options: [AiExtractStructuredFieldsOptionsField]? = nil) {
        self.key = key
        self.description = description
        self.displayName = displayName
        self.prompt = prompt
        self.type = type
        self.options = options
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        prompt = try container.decodeIfPresent(String.self, forKey: .prompt)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        options = try container.decodeIfPresent([AiExtractStructuredFieldsOptionsField].self, forKey: .options)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(displayName, forKey: .displayName)
        try container.encodeIfPresent(prompt, forKey: .prompt)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(options, forKey: .options)
    }

}
