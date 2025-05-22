import Foundation

/// The AI agent used for generating text.
public class AiAgentTextGen: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case basicGen = "basic_gen"
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

}
