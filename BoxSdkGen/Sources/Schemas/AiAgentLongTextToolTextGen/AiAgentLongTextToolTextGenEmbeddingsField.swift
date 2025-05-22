import Foundation

public class AiAgentLongTextToolTextGenEmbeddingsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case model
        case strategy
    }

    /// The model used for the AI agent for calculating embeddings.
    public let model: String?

    public let strategy: AiAgentLongTextToolTextGenEmbeddingsStrategyField?

    /// Initializer for a AiAgentLongTextToolTextGenEmbeddingsField.
    ///
    /// - Parameters:
    ///   - model: The model used for the AI agent for calculating embeddings.
    ///   - strategy: 
    public init(model: String? = nil, strategy: AiAgentLongTextToolTextGenEmbeddingsStrategyField? = nil) {
        self.model = model
        self.strategy = strategy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        model = try container.decodeIfPresent(String.self, forKey: .model)
        strategy = try container.decodeIfPresent(AiAgentLongTextToolTextGenEmbeddingsStrategyField.self, forKey: .strategy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(model, forKey: .model)
        try container.encodeIfPresent(strategy, forKey: .strategy)
    }

}
