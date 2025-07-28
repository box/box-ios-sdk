import Foundation

/// The AI agent used for generating text.
public class AiAgentTextGen: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case basicGen = "basic_gen"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The type of AI agent used for generating text.
    public let type: AiAgentTextGenTypeField

    public let basicGen: AiAgentBasicGenTool?

    /// Initializer for a AiAgentTextGen.
    ///
    /// - Parameters:
    ///   - type: The type of AI agent used for generating text.
    ///   - basicGen: 
    public init(type: AiAgentTextGenTypeField = AiAgentTextGenTypeField.aiAgentTextGen, basicGen: AiAgentBasicGenTool? = nil) {
        self.type = type
        self.basicGen = basicGen
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(AiAgentTextGenTypeField.self, forKey: .type)
        basicGen = try container.decodeIfPresent(AiAgentBasicGenTool.self, forKey: .basicGen)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(basicGen, forKey: .basicGen)
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
