import Foundation

/// A context object that can hold prior prompts and answers.
public class AiDialogueHistory: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case prompt
        case answer
        case createdAt = "created_at"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The prompt previously provided by the client and answered by the LLM.
    public let prompt: String?

    /// The answer previously provided by the LLM.
    public let answer: String?

    /// The ISO date formatted timestamp of when the previous answer to the prompt was created.
    public let createdAt: Date?

    /// Initializer for a AiDialogueHistory.
    ///
    /// - Parameters:
    ///   - prompt: The prompt previously provided by the client and answered by the LLM.
    ///   - answer: The answer previously provided by the LLM.
    ///   - createdAt: The ISO date formatted timestamp of when the previous answer to the prompt was created.
    public init(prompt: String? = nil, answer: String? = nil, createdAt: Date? = nil) {
        self.prompt = prompt
        self.answer = answer
        self.createdAt = createdAt
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        prompt = try container.decodeIfPresent(String.self, forKey: .prompt)
        answer = try container.decodeIfPresent(String.self, forKey: .answer)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(prompt, forKey: .prompt)
        try container.encodeIfPresent(answer, forKey: .answer)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
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
