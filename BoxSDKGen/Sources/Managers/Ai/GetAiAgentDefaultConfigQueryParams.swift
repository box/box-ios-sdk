import Foundation

public class GetAiAgentDefaultConfigQueryParams {
    /// The mode to filter the agent config to return.
    public let mode: GetAiAgentDefaultConfigQueryParamsModeField

    /// The ISO language code to return the agent config for.
    /// If the language is not supported the default agent config is returned.
    public let language: String?

    /// The model to return the default agent config for.
    public let model: String?

    /// Initializer for a GetAiAgentDefaultConfigQueryParams.
    ///
    /// - Parameters:
    ///   - mode: The mode to filter the agent config to return.
    ///   - language: The ISO language code to return the agent config for.
    ///     If the language is not supported the default agent config is returned.
    ///   - model: The model to return the default agent config for.
    public init(mode: GetAiAgentDefaultConfigQueryParamsModeField, language: String? = nil, model: String? = nil) {
        self.mode = mode
        self.language = language
        self.model = model
    }

}
