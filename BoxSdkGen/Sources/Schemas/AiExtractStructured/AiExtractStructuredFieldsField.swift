import Foundation

public class AiExtractStructuredFieldsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case key
        case description
        case displayName
        case prompt
        case type
        case options
        case fields
        case taxonomyKey = "taxonomy_key"
        case namespace
        case optionsRules = "options_rules"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A unique identifier for the field.
    public let key: String

    /// A description of the field.
    public let description: String?

    /// The display name of the field.
    public let displayName: String?

    /// The context about the key that may include how to find and format it.
    public let prompt: String?

    /// The type of the field. It can include but is not limited to `string`, `float`, `date`, `enum`, `multiSelect`,`taxonomy`, `struct`, and `table`.
    public let type: String?

    /// A list of options for this field. This is most often used in combination with the `enum` and `multiSelect` field types.
    public let options: [AiExtractStructuredFieldsOptionsField]?

    /// The nested fields for this field. Used with `struct` and `table` field types to define the nested structure.
    public let fields: [AiExtractSubField]?

    /// The identifier for a taxonomy, which corresponds to the `key` of the taxonomy source. Required if using `taxonomy` type field.
    public let taxonomyKey: String?

    /// The namespace of the taxonomy source. Required if using `taxonomy` type field from an existing taxonomy.
    public let namespace: String?

    public let optionsRules: AiOptionsRules?

    /// Initializer for a AiExtractStructuredFieldsField.
    ///
    /// - Parameters:
    ///   - key: A unique identifier for the field.
    ///   - description: A description of the field.
    ///   - displayName: The display name of the field.
    ///   - prompt: The context about the key that may include how to find and format it.
    ///   - type: The type of the field. It can include but is not limited to `string`, `float`, `date`, `enum`, `multiSelect`,`taxonomy`, `struct`, and `table`.
    ///   - options: A list of options for this field. This is most often used in combination with the `enum` and `multiSelect` field types.
    ///   - fields: The nested fields for this field. Used with `struct` and `table` field types to define the nested structure.
    ///   - taxonomyKey: The identifier for a taxonomy, which corresponds to the `key` of the taxonomy source. Required if using `taxonomy` type field.
    ///   - namespace: The namespace of the taxonomy source. Required if using `taxonomy` type field from an existing taxonomy.
    ///   - optionsRules: 
    public init(key: String, description: String? = nil, displayName: String? = nil, prompt: String? = nil, type: String? = nil, options: [AiExtractStructuredFieldsOptionsField]? = nil, fields: [AiExtractSubField]? = nil, taxonomyKey: String? = nil, namespace: String? = nil, optionsRules: AiOptionsRules? = nil) {
        self.key = key
        self.description = description
        self.displayName = displayName
        self.prompt = prompt
        self.type = type
        self.options = options
        self.fields = fields
        self.taxonomyKey = taxonomyKey
        self.namespace = namespace
        self.optionsRules = optionsRules
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        prompt = try container.decodeIfPresent(String.self, forKey: .prompt)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        options = try container.decodeIfPresent([AiExtractStructuredFieldsOptionsField].self, forKey: .options)
        fields = try container.decodeIfPresent([AiExtractSubField].self, forKey: .fields)
        taxonomyKey = try container.decodeIfPresent(String.self, forKey: .taxonomyKey)
        namespace = try container.decodeIfPresent(String.self, forKey: .namespace)
        optionsRules = try container.decodeIfPresent(AiOptionsRules.self, forKey: .optionsRules)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(displayName, forKey: .displayName)
        try container.encodeIfPresent(prompt, forKey: .prompt)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(options, forKey: .options)
        try container.encodeIfPresent(fields, forKey: .fields)
        try container.encodeIfPresent(taxonomyKey, forKey: .taxonomyKey)
        try container.encodeIfPresent(namespace, forKey: .namespace)
        try container.encodeIfPresent(optionsRules, forKey: .optionsRules)
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
