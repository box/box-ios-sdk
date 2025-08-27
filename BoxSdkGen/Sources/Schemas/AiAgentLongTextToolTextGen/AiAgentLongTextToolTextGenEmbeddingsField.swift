import Foundation

public class AiAgentLongTextToolTextGenEmbeddingsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case model
        case strategy
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
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
