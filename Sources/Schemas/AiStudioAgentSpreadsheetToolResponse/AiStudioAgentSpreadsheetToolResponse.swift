import Foundation

/// The AI agent tool used to handle spreadsheets and tabular data.
public class AiStudioAgentSpreadsheetToolResponse: AiStudioAgentSpreadsheetTool {
    private enum CodingKeys: String, CodingKey {
        case warnings
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// Warnings concerning tool.
    public let warnings: [String]?

    /// Initializer for a AiStudioAgentSpreadsheetToolResponse.
    ///
    /// - Parameters:
    ///   - model: The model used for the AI agent for spreadsheets. For specific model values, see the [available models list](g://box-ai/supported-models).
    ///   - numTokensForCompletion: The number of tokens for completion.
    ///   - llmEndpointParams: 
    ///   - warnings: Warnings concerning tool.
    public init(model: String? = nil, numTokensForCompletion: Int64? = nil, llmEndpointParams: AiLlmEndpointParams? = nil, warnings: [String]? = nil) {
        self.warnings = warnings

        super.init(model: model, numTokensForCompletion: numTokensForCompletion, llmEndpointParams: llmEndpointParams)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        warnings = try container.decodeIfPresent([String].self, forKey: .warnings)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(warnings, forKey: .warnings)
        try super.encode(to: encoder)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    override func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    override func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
