import Foundation

public class GetAiAgentsQueryParams {
    /// The mode to filter the agent config to return. Possible values are: `ask`, `text_gen`, and `extract`.
    public let mode: [String]?

    /// The fields to return in the response.
    public let fields: [String]?

    /// The state of the agents to return. Possible values are: `enabled`, `disabled` and `enabled_for_selected_users`.
    public let agentState: [String]?

    /// Whether to include the Box default agents in the response.
    public let includeBoxDefault: Bool?

    /// Defines the position marker at which to begin returning results.
    public let marker: String?

    /// The maximum number of items to return per page.
    public let limit: Int64?

    /// Initializer for a GetAiAgentsQueryParams.
    ///
    /// - Parameters:
    ///   - mode: The mode to filter the agent config to return. Possible values are: `ask`, `text_gen`, and `extract`.
    ///   - fields: The fields to return in the response.
    ///   - agentState: The state of the agents to return. Possible values are: `enabled`, `disabled` and `enabled_for_selected_users`.
    ///   - includeBoxDefault: Whether to include the Box default agents in the response.
    ///   - marker: Defines the position marker at which to begin returning results.
    ///   - limit: The maximum number of items to return per page.
    public init(mode: [String]? = nil, fields: [String]? = nil, agentState: [String]? = nil, includeBoxDefault: Bool? = nil, marker: String? = nil, limit: Int64? = nil) {
        self.mode = mode
        self.fields = fields
        self.agentState = agentState
        self.includeBoxDefault = includeBoxDefault
        self.marker = marker
        self.limit = limit
    }

}
