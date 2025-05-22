import Foundation

public class UpdateTaskByIdRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case action
        case message
        case dueAt = "due_at"
        case completionRule = "completion_rule"
    }

    /// The action the task assignee will be prompted to do. Must be
    /// 
    /// * `review` defines an approval task that can be approved or
    /// rejected
    /// * `complete` defines a general task which can be completed
    public let action: UpdateTaskByIdRequestBodyActionField?

    /// The message included with the task.
    public let message: String?

    /// When the task is due at.
    public let dueAt: Date?

    /// Defines which assignees need to complete this task before the task
    /// is considered completed.
    /// 
    /// * `all_assignees` (default) requires all assignees to review or
    /// approve the the task in order for it to be considered completed.
    /// * `any_assignee` accepts any one assignee to review or
    /// approve the the task in order for it to be considered completed.
    public let completionRule: UpdateTaskByIdRequestBodyCompletionRuleField?

    /// Initializer for a UpdateTaskByIdRequestBody.
    ///
    /// - Parameters:
    ///   - action: The action the task assignee will be prompted to do. Must be
    ///     
    ///     * `review` defines an approval task that can be approved or
    ///     rejected
    ///     * `complete` defines a general task which can be completed
    ///   - message: The message included with the task.
    ///   - dueAt: When the task is due at.
    ///   - completionRule: Defines which assignees need to complete this task before the task
    ///     is considered completed.
    ///     
    ///     * `all_assignees` (default) requires all assignees to review or
    ///     approve the the task in order for it to be considered completed.
    ///     * `any_assignee` accepts any one assignee to review or
    ///     approve the the task in order for it to be considered completed.
    public init(action: UpdateTaskByIdRequestBodyActionField? = nil, message: String? = nil, dueAt: Date? = nil, completionRule: UpdateTaskByIdRequestBodyCompletionRuleField? = nil) {
        self.action = action
        self.message = message
        self.dueAt = dueAt
        self.completionRule = completionRule
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        action = try container.decodeIfPresent(UpdateTaskByIdRequestBodyActionField.self, forKey: .action)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        dueAt = try container.decodeDateTimeIfPresent(forKey: .dueAt)
        completionRule = try container.decodeIfPresent(UpdateTaskByIdRequestBodyCompletionRuleField.self, forKey: .completionRule)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(action, forKey: .action)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeDateTimeIfPresent(field: dueAt, forKey: .dueAt)
        try container.encodeIfPresent(completionRule, forKey: .completionRule)
    }

}
