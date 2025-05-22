import Foundation

/// A task assignment defines which task is assigned to which user to complete.
public class TaskAssignment: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case item
        case assignedTo = "assigned_to"
        case message
        case completedAt = "completed_at"
        case assignedAt = "assigned_at"
        case remindedAt = "reminded_at"
        case resolutionState = "resolution_state"
        case assignedBy = "assigned_by"
    }

    /// The unique identifier for this task assignment
    public let id: String?

    /// `task_assignment`
    public let type: TaskAssignmentTypeField?

    public let item: FileMini?

    public let assignedTo: UserMini?

    /// A message that will is included with the task
    /// assignment. This is visible to the assigned user in the web and mobile
    /// UI.
    public let message: String?

    /// The date at which this task assignment was
    /// completed. This will be `null` if the task is not completed yet.
    public let completedAt: Date?

    /// The date at which this task was assigned to the user.
    public let assignedAt: Date?

    /// The date at which the assigned user was reminded of this task
    /// assignment.
    public let remindedAt: Date?

    /// The current state of the assignment. The available states depend on
    /// the `action` value of the task object.
    public let resolutionState: TaskAssignmentResolutionStateField?

    public let assignedBy: UserMini?

    /// Initializer for a TaskAssignment.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this task assignment
    ///   - type: `task_assignment`
    ///   - item: 
    ///   - assignedTo: 
    ///   - message: A message that will is included with the task
    ///     assignment. This is visible to the assigned user in the web and mobile
    ///     UI.
    ///   - completedAt: The date at which this task assignment was
    ///     completed. This will be `null` if the task is not completed yet.
    ///   - assignedAt: The date at which this task was assigned to the user.
    ///   - remindedAt: The date at which the assigned user was reminded of this task
    ///     assignment.
    ///   - resolutionState: The current state of the assignment. The available states depend on
    ///     the `action` value of the task object.
    ///   - assignedBy: 
    public init(id: String? = nil, type: TaskAssignmentTypeField? = nil, item: FileMini? = nil, assignedTo: UserMini? = nil, message: String? = nil, completedAt: Date? = nil, assignedAt: Date? = nil, remindedAt: Date? = nil, resolutionState: TaskAssignmentResolutionStateField? = nil, assignedBy: UserMini? = nil) {
        self.id = id
        self.type = type
        self.item = item
        self.assignedTo = assignedTo
        self.message = message
        self.completedAt = completedAt
        self.assignedAt = assignedAt
        self.remindedAt = remindedAt
        self.resolutionState = resolutionState
        self.assignedBy = assignedBy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(TaskAssignmentTypeField.self, forKey: .type)
        item = try container.decodeIfPresent(FileMini.self, forKey: .item)
        assignedTo = try container.decodeIfPresent(UserMini.self, forKey: .assignedTo)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        completedAt = try container.decodeDateTimeIfPresent(forKey: .completedAt)
        assignedAt = try container.decodeDateTimeIfPresent(forKey: .assignedAt)
        remindedAt = try container.decodeDateTimeIfPresent(forKey: .remindedAt)
        resolutionState = try container.decodeIfPresent(TaskAssignmentResolutionStateField.self, forKey: .resolutionState)
        assignedBy = try container.decodeIfPresent(UserMini.self, forKey: .assignedBy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(item, forKey: .item)
        try container.encodeIfPresent(assignedTo, forKey: .assignedTo)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeDateTimeIfPresent(field: completedAt, forKey: .completedAt)
        try container.encodeDateTimeIfPresent(field: assignedAt, forKey: .assignedAt)
        try container.encodeDateTimeIfPresent(field: remindedAt, forKey: .remindedAt)
        try container.encodeIfPresent(resolutionState, forKey: .resolutionState)
        try container.encodeIfPresent(assignedBy, forKey: .assignedBy)
    }

}
