import Foundation

/// A task allows for file-centric workflows within Box. Users can
/// create tasks on files and assign them to other users for them to complete the
/// tasks.
public class Task: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case item
        case dueAt = "due_at"
        case action
        case message
        case taskAssignmentCollection = "task_assignment_collection"
        case isCompleted = "is_completed"
        case createdBy = "created_by"
        case createdAt = "created_at"
        case completionRule = "completion_rule"
    }

    /// The unique identifier for this task
    public let id: String?

    /// `task`
    public let type: TaskTypeField?

    public let item: FileMini?

    /// When the task is due
    public let dueAt: Date?

    /// The type of task the task assignee will be prompted to
    /// perform.
    public let action: TaskActionField?

    /// A message that will be included with the task
    public let message: String?

    public let taskAssignmentCollection: TaskAssignments?

    /// Whether the task has been completed
    public let isCompleted: Bool?

    public let createdBy: UserMini?

    /// When the task object was created
    public let createdAt: Date?

    /// Defines which assignees need to complete this task before the task
    /// is considered completed.
    /// 
    /// * `all_assignees` requires all assignees to review or
    /// approve the the task in order for it to be considered completed.
    /// * `any_assignee` accepts any one assignee to review or
    /// approve the the task in order for it to be considered completed.
    public let completionRule: TaskCompletionRuleField?

    /// Initializer for a Task.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this task
    ///   - type: `task`
    ///   - item: 
    ///   - dueAt: When the task is due
    ///   - action: The type of task the task assignee will be prompted to
    ///     perform.
    ///   - message: A message that will be included with the task
    ///   - taskAssignmentCollection: 
    ///   - isCompleted: Whether the task has been completed
    ///   - createdBy: 
    ///   - createdAt: When the task object was created
    ///   - completionRule: Defines which assignees need to complete this task before the task
    ///     is considered completed.
    ///     
    ///     * `all_assignees` requires all assignees to review or
    ///     approve the the task in order for it to be considered completed.
    ///     * `any_assignee` accepts any one assignee to review or
    ///     approve the the task in order for it to be considered completed.
    public init(id: String? = nil, type: TaskTypeField? = nil, item: FileMini? = nil, dueAt: Date? = nil, action: TaskActionField? = nil, message: String? = nil, taskAssignmentCollection: TaskAssignments? = nil, isCompleted: Bool? = nil, createdBy: UserMini? = nil, createdAt: Date? = nil, completionRule: TaskCompletionRuleField? = nil) {
        self.id = id
        self.type = type
        self.item = item
        self.dueAt = dueAt
        self.action = action
        self.message = message
        self.taskAssignmentCollection = taskAssignmentCollection
        self.isCompleted = isCompleted
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.completionRule = completionRule
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(TaskTypeField.self, forKey: .type)
        item = try container.decodeIfPresent(FileMini.self, forKey: .item)
        dueAt = try container.decodeDateTimeIfPresent(forKey: .dueAt)
        action = try container.decodeIfPresent(TaskActionField.self, forKey: .action)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        taskAssignmentCollection = try container.decodeIfPresent(TaskAssignments.self, forKey: .taskAssignmentCollection)
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted)
        createdBy = try container.decodeIfPresent(UserMini.self, forKey: .createdBy)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        completionRule = try container.decodeIfPresent(TaskCompletionRuleField.self, forKey: .completionRule)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(item, forKey: .item)
        try container.encodeDateTimeIfPresent(field: dueAt, forKey: .dueAt)
        try container.encodeIfPresent(action, forKey: .action)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(taskAssignmentCollection, forKey: .taskAssignmentCollection)
        try container.encodeIfPresent(isCompleted, forKey: .isCompleted)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeIfPresent(completionRule, forKey: .completionRule)
    }

}
