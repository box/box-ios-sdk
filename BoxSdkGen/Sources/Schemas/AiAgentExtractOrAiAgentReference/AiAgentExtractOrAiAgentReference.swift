import Foundation

public enum AiAgentExtractOrAiAgentReference: Codable {
    case aiAgentExtract(AiAgentExtract)
    case aiAgentReference(AiAgentReference)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "ai_agent_extract":
                    if let content = try? AiAgentExtract(from: decoder) {
                        self = .aiAgentExtract(content)
                        return
                    }

                case "ai_agent_id":
                    if let content = try? AiAgentReference(from: decoder) {
                        self = .aiAgentReference(content)
                        return
                    }

                default:
                    throw DecodingError.typeMismatch(AiAgentExtractOrAiAgentReference.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The Decoded object contains an unexpected value for key type"))

                }
            }

        }

        throw DecodingError.typeMismatch(AiAgentExtractOrAiAgentReference.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .aiAgentExtract(let aiAgentExtract):
            try aiAgentExtract.encode(to: encoder)
        case .aiAgentReference(let aiAgentReference):
            try aiAgentReference.encode(to: encoder)
        }
    }

}
