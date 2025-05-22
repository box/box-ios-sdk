import Foundation

/// AI response
public class AiResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case answer
        case createdAt = "created_at"
        case completionReason = "completion_reason"
        case aiAgentInfo = "ai_agent_info"
    }

    /// The answer provided by the LLM.
    public let answer: String

    /// The ISO date formatted timestamp of when the answer to the prompt was created.
    public let createdAt: Date

    /// The reason the response finishes.
    public let completionReason: String?

    public let aiAgentInfo: AiAgentInfo?

    /// Initializer for a AiResponse.
    ///
    /// - Parameters:
    ///   - answer: The answer provided by the LLM.
    ///   - createdAt: The ISO date formatted timestamp of when the answer to the prompt was created.
    ///   - completionReason: The reason the response finishes.
    ///   - aiAgentInfo: 
    public init(answer: String, createdAt: Date, completionReason: String? = nil, aiAgentInfo: AiAgentInfo? = nil) {
        self.answer = answer
        self.createdAt = createdAt
        self.completionReason = completionReason
        self.aiAgentInfo = aiAgentInfo
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        answer = try container.decode(String.self, forKey: .answer)
        createdAt = try container.decodeDateTime(forKey: .createdAt)
        completionReason = try container.decodeIfPresent(String.self, forKey: .completionReason)
        aiAgentInfo = try container.decodeIfPresent(AiAgentInfo.self, forKey: .aiAgentInfo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(answer, forKey: .answer)
        try container.encodeDateTime(field: createdAt, forKey: .createdAt)
        try container.encodeIfPresent(completionReason, forKey: .completionReason)
        try container.encodeIfPresent(aiAgentInfo, forKey: .aiAgentInfo)
    }

}
