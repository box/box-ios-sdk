import Foundation

/// AI metadata freeform extraction request object.
public class AiExtract: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case prompt
        case items
        case aiAgent = "ai_agent"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The prompt provided to a Large Language Model (LLM) in the request. The prompt can be up to 10000 characters long and it can be an XML or a JSON schema.
    public let prompt: String

    /// The items that LLM will process. Currently, you can use files only.
    public let items: [AiItemBase]

    public let aiAgent: AiExtractAgent?

    /// Initializer for a AiExtract.
    ///
    /// - Parameters:
    ///   - prompt: The prompt provided to a Large Language Model (LLM) in the request. The prompt can be up to 10000 characters long and it can be an XML or a JSON schema.
    ///   - items: The items that LLM will process. Currently, you can use files only.
    ///   - aiAgent: 
    public init(prompt: String, items: [AiItemBase], aiAgent: AiExtractAgent? = nil) {
        self.prompt = prompt
        self.items = items
        self.aiAgent = aiAgent
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        prompt = try container.decode(String.self, forKey: .prompt)
        items = try container.decode([AiItemBase].self, forKey: .items)
        aiAgent = try container.decodeIfPresent(AiExtractAgent.self, forKey: .aiAgent)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(items, forKey: .items)
        try container.encodeIfPresent(aiAgent, forKey: .aiAgent)
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
