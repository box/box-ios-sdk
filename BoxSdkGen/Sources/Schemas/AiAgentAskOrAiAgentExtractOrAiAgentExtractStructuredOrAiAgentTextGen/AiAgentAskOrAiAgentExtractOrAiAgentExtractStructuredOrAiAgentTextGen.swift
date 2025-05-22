import Foundation

public enum AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen: Codable {
    case aiAgentAsk(AiAgentAsk)
    case aiAgentExtract(AiAgentExtract)
    case aiAgentExtractStructured(AiAgentExtractStructured)
    case aiAgentTextGen(AiAgentTextGen)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "ai_agent_ask":
                    if let content = try? AiAgentAsk(from: decoder) {
                        self = .aiAgentAsk(content)
                        return
                    }

                case "ai_agent_extract":
                    if let content = try? AiAgentExtract(from: decoder) {
                        self = .aiAgentExtract(content)
                        return
                    }

                case "ai_agent_extract_structured":
                    if let content = try? AiAgentExtractStructured(from: decoder) {
                        self = .aiAgentExtractStructured(content)
                        return
                    }

                case "ai_agent_text_gen":
                    if let content = try? AiAgentTextGen(from: decoder) {
                        self = .aiAgentTextGen(content)
                        return
                    }

                default:
                    throw DecodingError.typeMismatch(AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The Decoded object contains an unexpected value for key type"))

                }
            }

        }

        throw DecodingError.typeMismatch(AiAgentAskOrAiAgentExtractOrAiAgentExtractStructuredOrAiAgentTextGen.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .aiAgentAsk(let aiAgentAsk):
            try aiAgentAsk.encode(to: encoder)
        case .aiAgentExtract(let aiAgentExtract):
            try aiAgentExtract.encode(to: encoder)
        case .aiAgentExtractStructured(let aiAgentExtractStructured):
            try aiAgentExtractStructured.encode(to: encoder)
        case .aiAgentTextGen(let aiAgentTextGen):
            try aiAgentTextGen.encode(to: encoder)
        }
    }

}
