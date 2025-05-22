import Foundation

public class CreateTaskRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case item
        case action
        case message
        case dueAt = "due_at"
        case completionRule = "completion_rule"
    }

    /// The file to attach the task to.
    public let item: CreateTaskRequestBodyItemField

    /// The action the task assignee will be prompted to do. Must be
    /// 
    /// * `review` defines an approval task that can be approved or
    /// rejected
    /// * `complete` defines a general task which can be completed
    public let action: CreateTaskRequestBodyActionField?

    /// An optional message to include with the task.
    public let message: String?

    /// Defines when the task is due. Defaults to `null` if not
    /// provided.
    public let dueAt: Date?

    /// Defines which assignees need to complete this task before the task
    /// is considered completed.
    /// 
    /// * `all_assignees` (default) requires all assignees to review or
    /// approve the the task in order for it to be considered completed.
    /// * `any_assignee` accepts any one assignee to review or
    /// approve the the task in order for it to be considered completed.
    public let completionRule: CreateTaskRequestBodyCompletionRuleField?

    /// Initializer for a CreateTaskRequestBody.
    ///
    /// - Parameters:
    ///   - item: The file to attach the task to.
    ///   - action: The action the task assignee will be prompted to do. Must be
    ///     
    ///     * `review` defines an approval task that can be approved or
    ///     rejected
    ///     * `complete` defines a general task which can be completed
    ///   - message: An optional message to include with the task.
    ///   - dueAt: Defines when the task is due. Defaults to `null` if not
    ///     provided.
    ///   - completionRule: Defines which assignees need to complete this task before the task
    ///     is considered completed.
    ///     
    ///     * `all_assignees` (default) requires all assignees to review or
    ///     approve the the task in order for it to be considered completed.
    ///     * `any_assignee` accepts any one assignee to review or
    ///     approve the the task in order for it to be considered completed.
    public init(item: CreateTaskRequestBodyItemField, action: CreateTaskRequestBodyActionField? = nil, message: String? = nil, dueAt: Date? = nil, completionRule: CreateTaskRequestBodyCompletionRuleField? = nil) {
        self.item = item
        self.action = action
        self.message = message
        self.dueAt = dueAt
        self.completionRule = completionRule
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        item = try container.decode(CreateTaskRequestBodyItemField.self, forKey: .item)
        action = try container.decodeIfPresent(CreateTaskRequestBodyActionField.self, forKey: .action)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        dueAt = try container.decodeDateTimeIfPresent(forKey: .dueAt)
        completionRule = try container.decodeIfPresent(CreateTaskRequestBodyCompletionRuleField.self, forKey: .completionRule)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(item, forKey: .item)
        try container.encodeIfPresent(action, forKey: .action)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeDateTimeIfPresent(field: dueAt, forKey: .dueAt)
        try container.encodeIfPresent(completionRule, forKey: .completionRule)
    }

}
