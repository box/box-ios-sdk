import Foundation

/// The AI agent to be used to handle the AI ask request.
public enum AiAskAgent: Codable {
    case aiAgentReference(AiAgentReference)
    case aiAgentAsk(AiAgentAsk)

    private enum DiscriminatorCodingKey: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DiscriminatorCodingKey.self) {
            if let discriminator_0 = try? container.decode(String.self, forKey: .type) {
                switch discriminator_0 {
                case "ai_agent_id":
                    if let content = try? AiAgentReference(from: decoder) {
                        self = .aiAgentReference(content)
                        return
                    }

                case "ai_agent_ask":
                    if let content = try? AiAgentAsk(from: decoder) {
                        self = .aiAgentAsk(content)
                        return
                    }

                default:
                    break
                }
            }

        }

        throw DecodingError.typeMismatch(AiAskAgent.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "The type of the decoded object cannot be determined."))

    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .aiAgentReference(let aiAgentReference):
            try aiAgentReference.encode(to: encoder)
        case .aiAgentAsk(let aiAgentAsk):
            try aiAgentAsk.encode(to: encoder)
        }
    }

}
