import Foundation

/// Box Relay Workflows are objects that represent a named collection of flows.
/// 
/// You application must be authorized to use the `Manage Box Relay` application
/// scope within the developer console in order to use this resource.
public class WorkflowMini: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
        case description
        case isEnabled = "is_enabled"
    }

    /// The unique identifier for the workflow
    public let id: String?

    /// `workflow`
    public let type: WorkflowMiniTypeField?

    /// The name of the workflow
    public let name: String?

    /// The description for a workflow.
    public let description: String?

    /// Specifies if this workflow is enabled
    public let isEnabled: Bool?

    /// Initializer for a WorkflowMini.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the workflow
    ///   - type: `workflow`
    ///   - name: The name of the workflow
    ///   - description: The description for a workflow.
    ///   - isEnabled: Specifies if this workflow is enabled
    public init(id: String? = nil, type: WorkflowMiniTypeField? = nil, name: String? = nil, description: String? = nil, isEnabled: Bool? = nil) {
        self.id = id
        self.type = type
        self.name = name
        self.description = description
        self.isEnabled = isEnabled
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(WorkflowMiniTypeField.self, forKey: .type)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(isEnabled, forKey: .isEnabled)
    }

}
