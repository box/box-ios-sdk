import Foundation

/// Box Relay Workflows are objects that represent a named collection of flows.
/// 
/// You application must be authorized to use the `Manage Box Relay` application
/// scope within the developer console in order to use this resource.
public class WorkflowFull: Workflow {
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case createdBy = "created_by"
        case modifiedBy = "modified_by"
    }

    /// The date and time when the workflow was created on Box
    public let createdAt: Date?

    /// The date and time when the workflow was last updated on Box
    public let modifiedAt: Date?

    public let createdBy: UserBase?

    public let modifiedBy: UserBase?

    /// Initializer for a WorkflowFull.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the workflow
    ///   - type: `workflow`
    ///   - name: The name of the workflow
    ///   - description: The description for a workflow.
    ///   - isEnabled: Specifies if this workflow is enabled
    ///   - flows: A list of flows assigned to a workflow.
    ///   - createdAt: The date and time when the workflow was created on Box
    ///   - modifiedAt: The date and time when the workflow was last updated on Box
    ///   - createdBy: 
    ///   - modifiedBy: 
    public init(id: String? = nil, type: WorkflowMiniTypeField? = nil, name: String? = nil, description: String? = nil, isEnabled: Bool? = nil, flows: [WorkflowFlowsField]? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, createdBy: UserBase? = nil, modifiedBy: UserBase? = nil) {
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.createdBy = createdBy
        self.modifiedBy = modifiedBy

        super.init(id: id, type: type, name: name, description: description, isEnabled: isEnabled, flows: flows)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
        createdBy = try container.decodeIfPresent(UserBase.self, forKey: .createdBy)
        modifiedBy = try container.decodeIfPresent(UserBase.self, forKey: .modifiedBy)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeIfPresent(modifiedBy, forKey: .modifiedBy)
        try super.encode(to: encoder)
    }

}
