import Foundation

/// A nested field definition for structured and table field types used in AI extraction.
public class AiExtractSubField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case key
        case description
        case displayName
        case prompt
        case type
        case options
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A unique identifier for the nested field.
    public let key: String

    /// A description of the nested field.
    public let description: String?

    /// The display name of the nested field.
    public let displayName: String?

    /// Context about the nested field that may include how to find and how to format it.
    public let prompt: String?

    /// The type of the nested field. Allowed types include `string`, `float`, `date`, `number`, `text`, `boolean`, `enum` and `multiSelect`.
    public let type: String?

    /// A list of options for this nested field. Used with `enum` and `multiSelect` types.
    public let options: [AiExtractFieldOption]?

    /// Initializer for a AiExtractSubField.
    ///
    /// - Parameters:
    ///   - key: A unique identifier for the nested field.
    ///   - description: A description of the nested field.
    ///   - displayName: The display name of the nested field.
    ///   - prompt: Context about the nested field that may include how to find and how to format it.
    ///   - type: The type of the nested field. Allowed types include `string`, `float`, `date`, `number`, `text`, `boolean`, `enum` and `multiSelect`.
    ///   - options: A list of options for this nested field. Used with `enum` and `multiSelect` types.
    public init(key: String, description: String? = nil, displayName: String? = nil, prompt: String? = nil, type: String? = nil, options: [AiExtractFieldOption]? = nil) {
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
        options = try container.decodeIfPresent([AiExtractFieldOption].self, forKey: .options)
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
