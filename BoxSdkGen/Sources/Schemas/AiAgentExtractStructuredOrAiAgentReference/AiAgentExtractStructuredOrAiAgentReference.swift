import Foundation

public enum AiAgentExtractStructuredOrAiAgentReference: Codable {
    case aiAgentExtractStructured(AiAgentExtractStructured)
    case aiAgentReference(AiAgentReference)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "ai_agent_extract_structured":
                    if let content = try? AiAgentExtractStructured(from: decoder) {
                        self = .aiAgentExtractStructured(content)
                        return
                    }

                case "ai_agent_id":
                    if let content = try? AiAgentReference(from: decoder) {
                        self = .aiAgentReference(content)
                        return
                    }

                default:
                    throw DecodingError.typeMismatch(AiAgentExtractStructuredOrAiAgentReference.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The Decoded object contains an unexpected value for key type"))

                }
            }

        }

        throw DecodingError.typeMismatch(AiAgentExtractStructuredOrAiAgentReference.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .aiAgentExtractStructured(let aiAgentExtractStructured):
            try aiAgentExtractStructured.encode(to: encoder)
        case .aiAgentReference(let aiAgentReference):
            try aiAgentReference.encode(to: encoder)
        }
    }

}
