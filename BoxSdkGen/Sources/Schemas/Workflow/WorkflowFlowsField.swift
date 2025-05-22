import Foundation

public class WorkflowFlowsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case trigger
        case outcomes
        case createdAt = "created_at"
        case createdBy = "created_by"
    }

    /// The identifier of the flow
    public let id: String?

    /// The flow's resource type
    public let type: WorkflowFlowsTypeField?

    public let trigger: WorkflowFlowsTriggerField?

    public let outcomes: [WorkflowFlowsOutcomesField]?

    /// When this flow was created
    public let createdAt: Date?

    public let createdBy: UserBase?

    /// Initializer for a WorkflowFlowsField.
    ///
    /// - Parameters:
    ///   - id: The identifier of the flow
    ///   - type: The flow's resource type
    ///   - trigger: 
    ///   - outcomes: 
    ///   - createdAt: When this flow was created
    ///   - createdBy: 
    public init(id: String? = nil, type: WorkflowFlowsTypeField? = nil, trigger: WorkflowFlowsTriggerField? = nil, outcomes: [WorkflowFlowsOutcomesField]? = nil, createdAt: Date? = nil, createdBy: UserBase? = nil) {
        self.id = id
        self.type = type
        self.trigger = trigger
        self.outcomes = outcomes
        self.createdAt = createdAt
        self.createdBy = createdBy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(WorkflowFlowsTypeField.self, forKey: .type)
        trigger = try container.decodeIfPresent(WorkflowFlowsTriggerField.self, forKey: .trigger)
        outcomes = try container.decodeIfPresent([WorkflowFlowsOutcomesField].self, forKey: .outcomes)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        createdBy = try container.decodeIfPresent(UserBase.self, forKey: .createdBy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(trigger, forKey: .trigger)
        try container.encodeIfPresent(outcomes, forKey: .outcomes)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
    }

}
