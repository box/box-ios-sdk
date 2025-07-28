import Foundation

/// The AI agent used to handle queries.
public class AiAgentAsk: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case longText = "long_text"
        case basicText = "basic_text"
        case spreadsheet
        case longTextMulti = "long_text_multi"
        case basicTextMulti = "basic_text_multi"
        case basicImage = "basic_image"
        case basicImageMulti = "basic_image_multi"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The type of AI agent used to handle queries.
    public let type: AiAgentAskTypeField

    public let longText: AiAgentLongTextTool?

    public let basicText: AiAgentBasicTextTool?

    public let spreadsheet: AiAgentSpreadsheetTool?

    public let longTextMulti: AiAgentLongTextTool?

    public let basicTextMulti: AiAgentBasicTextTool?

    public let basicImage: AiAgentBasicTextTool?

    public let basicImageMulti: AiAgentBasicTextTool?

    /// Initializer for a AiAgentAsk.
    ///
    /// - Parameters:
    ///   - type: The type of AI agent used to handle queries.
    ///   - longText: 
    ///   - basicText: 
    ///   - spreadsheet: 
    ///   - longTextMulti: 
    ///   - basicTextMulti: 
    ///   - basicImage: 
    ///   - basicImageMulti: 
    public init(type: AiAgentAskTypeField = AiAgentAskTypeField.aiAgentAsk, longText: AiAgentLongTextTool? = nil, basicText: AiAgentBasicTextTool? = nil, spreadsheet: AiAgentSpreadsheetTool? = nil, longTextMulti: AiAgentLongTextTool? = nil, basicTextMulti: AiAgentBasicTextTool? = nil, basicImage: AiAgentBasicTextTool? = nil, basicImageMulti: AiAgentBasicTextTool? = nil) {
        self.type = type
        self.longText = longText
        self.basicText = basicText
        self.spreadsheet = spreadsheet
        self.longTextMulti = longTextMulti
        self.basicTextMulti = basicTextMulti
        self.basicImage = basicImage
        self.basicImageMulti = basicImageMulti
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(AiAgentAskTypeField.self, forKey: .type)
        longText = try container.decodeIfPresent(AiAgentLongTextTool.self, forKey: .longText)
        basicText = try container.decodeIfPresent(AiAgentBasicTextTool.self, forKey: .basicText)
        spreadsheet = try container.decodeIfPresent(AiAgentSpreadsheetTool.self, forKey: .spreadsheet)
        longTextMulti = try container.decodeIfPresent(AiAgentLongTextTool.self, forKey: .longTextMulti)
        basicTextMulti = try container.decodeIfPresent(AiAgentBasicTextTool.self, forKey: .basicTextMulti)
        basicImage = try container.decodeIfPresent(AiAgentBasicTextTool.self, forKey: .basicImage)
        basicImageMulti = try container.decodeIfPresent(AiAgentBasicTextTool.self, forKey: .basicImageMulti)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(longText, forKey: .longText)
        try container.encodeIfPresent(basicText, forKey: .basicText)
        try container.encodeIfPresent(spreadsheet, forKey: .spreadsheet)
        try container.encodeIfPresent(longTextMulti, forKey: .longTextMulti)
        try container.encodeIfPresent(basicTextMulti, forKey: .basicTextMulti)
        try container.encodeIfPresent(basicImage, forKey: .basicImage)
        try container.encodeIfPresent(basicImageMulti, forKey: .basicImageMulti)
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
