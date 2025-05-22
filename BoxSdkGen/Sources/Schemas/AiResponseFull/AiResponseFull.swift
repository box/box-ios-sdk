import Foundation

/// AI ask response
public class AiResponseFull: AiResponse {
    private enum CodingKeys: String, CodingKey {
        case citations
    }

    /// The citations of the LLM's answer reference.
    public let citations: [AiCitation]?

    /// Initializer for a AiResponseFull.
    ///
    /// - Parameters:
    ///   - answer: The answer provided by the LLM.
    ///   - createdAt: The ISO date formatted timestamp of when the answer to the prompt was created.
    ///   - completionReason: The reason the response finishes.
    ///   - aiAgentInfo: 
    ///   - citations: The citations of the LLM's answer reference.
    public init(answer: String, createdAt: Date, completionReason: String? = nil, aiAgentInfo: AiAgentInfo? = nil, citations: [AiCitation]? = nil) {
        self.citations = citations

        super.init(answer: answer, createdAt: createdAt, completionReason: completionReason, aiAgentInfo: aiAgentInfo)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        citations = try container.decodeIfPresent([AiCitation].self, forKey: .citations)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(citations, forKey: .citations)
        try super.encode(to: encoder)
    }

}
