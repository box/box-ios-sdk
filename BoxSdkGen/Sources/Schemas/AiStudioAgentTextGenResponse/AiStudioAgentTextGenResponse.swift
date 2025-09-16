import Foundation

/// The AI agent to be used to generate text.
public class AiStudioAgentTextGenResponse: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case accessState = "access_state"
        case description
        case type
        case customInstructions = "custom_instructions"
        case suggestedQuestions = "suggested_questions"
        case basicGen = "basic_gen"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The state of the AI Agent capability. Possible values are: `enabled` and `disabled`.
    public let accessState: String

    /// The description of the AI agent.
    public let description: String

    /// The type of AI agent used for generating text.
    public let type: AiStudioAgentTextGenResponseTypeField

    /// Custom instructions for the AI agent.
    @CodableTriState public private(set) var customInstructions: String?

    /// Suggested questions for the AI agent. If null, suggested question will be generated. If empty, no suggested questions will be displayed.
    public let suggestedQuestions: [String]?

    public let basicGen: AiStudioAgentBasicGenToolResponse?

    /// Initializer for a AiStudioAgentTextGenResponse.
    ///
    /// - Parameters:
    ///   - accessState: The state of the AI Agent capability. Possible values are: `enabled` and `disabled`.
    ///   - description: The description of the AI agent.
    ///   - type: The type of AI agent used for generating text.
    ///   - customInstructions: Custom instructions for the AI agent.
    ///   - suggestedQuestions: Suggested questions for the AI agent. If null, suggested question will be generated. If empty, no suggested questions will be displayed.
    ///   - basicGen: 
    public init(accessState: String, description: String, type: AiStudioAgentTextGenResponseTypeField = AiStudioAgentTextGenResponseTypeField.aiAgentTextGen, customInstructions: TriStateField<String> = nil, suggestedQuestions: [String]? = nil, basicGen: AiStudioAgentBasicGenToolResponse? = nil) {
        self.accessState = accessState
        self.description = description
        self.type = type
        self._customInstructions = CodableTriState(state: customInstructions)
        self.suggestedQuestions = suggestedQuestions
        self.basicGen = basicGen
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessState = try container.decode(String.self, forKey: .accessState)
        description = try container.decode(String.self, forKey: .description)
        type = try container.decode(AiStudioAgentTextGenResponseTypeField.self, forKey: .type)
        customInstructions = try container.decodeIfPresent(String.self, forKey: .customInstructions)
        suggestedQuestions = try container.decodeIfPresent([String].self, forKey: .suggestedQuestions)
        basicGen = try container.decodeIfPresent(AiStudioAgentBasicGenToolResponse.self, forKey: .basicGen)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessState, forKey: .accessState)
        try container.encode(description, forKey: .description)
        try container.encode(type, forKey: .type)
        try container.encode(field: _customInstructions.state, forKey: .customInstructions)
        try container.encodeIfPresent(suggestedQuestions, forKey: .suggestedQuestions)
        try container.encodeIfPresent(basicGen, forKey: .basicGen)
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
