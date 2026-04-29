import Foundation

/// An Automate action that can start a workflow.
public class AutomateWorkflowActionV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case workflow
        case type
        case actionType = "action_type"
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case createdBy = "created_by"
        case updatedBy = "updated_by"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The identifier for the Automate action.
    public let id: String

    public let workflow: AutomateWorkflowReferenceV2026R0

    /// The object type for this workflow action wrapper.
    public let type: AutomateWorkflowActionV2026R0TypeField

    /// The type that defines the behavior of this action.
    public let actionType: AutomateWorkflowActionV2026R0ActionTypeField

    /// A human-readable description of the workflow action.
    public let description: String?

    /// The date and time when the action was created.
    public let createdAt: Date?

    /// The date and time when the action was last updated.
    public let updatedAt: Date?

    public let createdBy: UserMiniV2026R0?

    public let updatedBy: UserMiniV2026R0?

    /// Initializer for a AutomateWorkflowActionV2026R0.
    ///
    /// - Parameters:
    ///   - id: The identifier for the Automate action.
    ///   - workflow: 
    ///   - type: The object type for this workflow action wrapper.
    ///   - actionType: The type that defines the behavior of this action.
    ///   - description: A human-readable description of the workflow action.
    ///   - createdAt: The date and time when the action was created.
    ///   - updatedAt: The date and time when the action was last updated.
    ///   - createdBy: 
    ///   - updatedBy: 
    public init(id: String, workflow: AutomateWorkflowReferenceV2026R0, type: AutomateWorkflowActionV2026R0TypeField = AutomateWorkflowActionV2026R0TypeField.workflowAction, actionType: AutomateWorkflowActionV2026R0ActionTypeField = AutomateWorkflowActionV2026R0ActionTypeField.runWorkflow, description: String? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, createdBy: UserMiniV2026R0? = nil, updatedBy: UserMiniV2026R0? = nil) {
        self.id = id
        self.workflow = workflow
        self.type = type
        self.actionType = actionType
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.createdBy = createdBy
        self.updatedBy = updatedBy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        workflow = try container.decode(AutomateWorkflowReferenceV2026R0.self, forKey: .workflow)
        type = try container.decode(AutomateWorkflowActionV2026R0TypeField.self, forKey: .type)
        actionType = try container.decode(AutomateWorkflowActionV2026R0ActionTypeField.self, forKey: .actionType)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        updatedAt = try container.decodeDateTimeIfPresent(forKey: .updatedAt)
        createdBy = try container.decodeIfPresent(UserMiniV2026R0.self, forKey: .createdBy)
        updatedBy = try container.decodeIfPresent(UserMiniV2026R0.self, forKey: .updatedBy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(workflow, forKey: .workflow)
        try container.encode(type, forKey: .type)
        try container.encode(actionType, forKey: .actionType)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeIfPresent(updatedBy, forKey: .updatedBy)
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
