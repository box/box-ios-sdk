import Foundation

/// The AI agent to be used for structured extraction.
public class AiAgentExtractStructured: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case longText = "long_text"
        case basicText = "basic_text"
        case basicImage = "basic_image"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The type of AI agent to be used for extraction.
    public let type: AiAgentExtractStructuredTypeField

    public let longText: AiAgentLongTextTool?

    public let basicText: AiAgentBasicTextTool?

    public let basicImage: AiAgentBasicTextTool?

    /// Initializer for a AiAgentExtractStructured.
    ///
    /// - Parameters:
    ///   - type: The type of AI agent to be used for extraction.
    ///   - longText: 
    ///   - basicText: 
    ///   - basicImage: 
    public init(type: AiAgentExtractStructuredTypeField = AiAgentExtractStructuredTypeField.aiAgentExtractStructured, longText: AiAgentLongTextTool? = nil, basicText: AiAgentBasicTextTool? = nil, basicImage: AiAgentBasicTextTool? = nil) {
        self.type = type
        self.longText = longText
        self.basicText = basicText
        self.basicImage = basicImage
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(AiAgentExtractStructuredTypeField.self, forKey: .type)
        longText = try container.decodeIfPresent(AiAgentLongTextTool.self, forKey: .longText)
        basicText = try container.decodeIfPresent(AiAgentBasicTextTool.self, forKey: .basicText)
        basicImage = try container.decodeIfPresent(AiAgentBasicTextTool.self, forKey: .basicImage)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(longText, forKey: .longText)
        try container.encodeIfPresent(basicText, forKey: .basicText)
        try container.encodeIfPresent(basicImage, forKey: .basicImage)
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
