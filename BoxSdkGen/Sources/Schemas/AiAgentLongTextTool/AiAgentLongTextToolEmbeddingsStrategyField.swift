import Foundation

public class AiAgentLongTextToolEmbeddingsStrategyField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case numTokensPerChunk = "num_tokens_per_chunk"
    }

    /// The strategy used for the AI agent for calculating embeddings.
    public let id: String?

    /// The number of tokens per chunk.
    public let numTokensPerChunk: Int64?

    /// Initializer for a AiAgentLongTextToolEmbeddingsStrategyField.
    ///
    /// - Parameters:
    ///   - id: The strategy used for the AI agent for calculating embeddings.
    ///   - numTokensPerChunk: The number of tokens per chunk.
    public init(id: String? = nil, numTokensPerChunk: Int64? = nil) {
        self.id = id
        self.numTokensPerChunk = numTokensPerChunk
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        numTokensPerChunk = try container.decodeIfPresent(Int64.self, forKey: .numTokensPerChunk)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(numTokensPerChunk, forKey: .numTokensPerChunk)
    }

}
