import Foundation

/// AI LLM endpoint params OpenAI object.
public class AiLlmEndpointParamsOpenAi: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case temperature
        case topP = "top_p"
        case frequencyPenalty = "frequency_penalty"
        case presencePenalty = "presence_penalty"
        case stop
    }

    /// The type of the AI LLM endpoint params object for OpenAI.
    /// This parameter is **required**.
    public let type: AiLlmEndpointParamsOpenAiTypeField

    /// What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, 
    /// while lower values like 0.2 will make it more focused and deterministic. 
    /// We generally recommend altering this or `top_p` but not both.
    @CodableTriState public private(set) var temperature: Double?

    /// An alternative to sampling with temperature, called nucleus sampling, where the model considers the results 
    /// of the tokens with `top_p` probability mass. So 0.1 means only the tokens comprising the top 10% probability 
    /// mass are considered. We generally recommend altering this or temperature but not both.
    @CodableTriState public private(set) var topP: Double?

    /// A number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the 
    /// text so far, decreasing the model's likelihood to repeat the same line verbatim.
    @CodableTriState public private(set) var frequencyPenalty: Double?

    /// A number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
    @CodableTriState public private(set) var presencePenalty: Double?

    /// Up to 4 sequences where the API will stop generating further tokens.
    @CodableTriState public private(set) var stop: String?

    /// Initializer for a AiLlmEndpointParamsOpenAi.
    ///
    /// - Parameters:
    ///   - type: The type of the AI LLM endpoint params object for OpenAI.
    ///     This parameter is **required**.
    ///   - temperature: What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, 
    ///     while lower values like 0.2 will make it more focused and deterministic. 
    ///     We generally recommend altering this or `top_p` but not both.
    ///   - topP: An alternative to sampling with temperature, called nucleus sampling, where the model considers the results 
    ///     of the tokens with `top_p` probability mass. So 0.1 means only the tokens comprising the top 10% probability 
    ///     mass are considered. We generally recommend altering this or temperature but not both.
    ///   - frequencyPenalty: A number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the 
    ///     text so far, decreasing the model's likelihood to repeat the same line verbatim.
    ///   - presencePenalty: A number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
    ///   - stop: Up to 4 sequences where the API will stop generating further tokens.
    public init(type: AiLlmEndpointParamsOpenAiTypeField = AiLlmEndpointParamsOpenAiTypeField.openaiParams, temperature: TriStateField<Double> = nil, topP: TriStateField<Double> = nil, frequencyPenalty: TriStateField<Double> = nil, presencePenalty: TriStateField<Double> = nil, stop: TriStateField<String> = nil) {
        self.type = type
        self._temperature = CodableTriState(state: temperature)
        self._topP = CodableTriState(state: topP)
        self._frequencyPenalty = CodableTriState(state: frequencyPenalty)
        self._presencePenalty = CodableTriState(state: presencePenalty)
        self._stop = CodableTriState(state: stop)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(AiLlmEndpointParamsOpenAiTypeField.self, forKey: .type)
        temperature = try container.decodeIfPresent(Double.self, forKey: .temperature)
        topP = try container.decodeIfPresent(Double.self, forKey: .topP)
        frequencyPenalty = try container.decodeIfPresent(Double.self, forKey: .frequencyPenalty)
        presencePenalty = try container.decodeIfPresent(Double.self, forKey: .presencePenalty)
        stop = try container.decodeIfPresent(String.self, forKey: .stop)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(field: _temperature.state, forKey: .temperature)
        try container.encode(field: _topP.state, forKey: .topP)
        try container.encode(field: _frequencyPenalty.state, forKey: .frequencyPenalty)
        try container.encode(field: _presencePenalty.state, forKey: .presencePenalty)
        try container.encode(field: _stop.state, forKey: .stop)
    }

}
