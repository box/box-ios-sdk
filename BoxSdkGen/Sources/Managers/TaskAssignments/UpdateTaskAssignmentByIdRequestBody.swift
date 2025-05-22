import Foundation

public class UpdateTaskAssignmentByIdRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case message
        case resolutionState = "resolution_state"
    }

    /// An optional message by the assignee that can be added to the task.
    public let message: String?

    /// The state of the task assigned to the user.
    /// 
    /// * For a task with an `action` value of `complete` this can be
    /// `incomplete` or `completed`.
    /// * For a task with an `action` of `review` this can be
    /// `incomplete`, `approved`, or `rejected`.
    public let resolutionState: UpdateTaskAssignmentByIdRequestBodyResolutionStateField?

    /// Initializer for a UpdateTaskAssignmentByIdRequestBody.
    ///
    /// - Parameters:
    ///   - message: An optional message by the assignee that can be added to the task.
    ///   - resolutionState: The state of the task assigned to the user.
    ///     
    ///     * For a task with an `action` value of `complete` this can be
    ///     `incomplete` or `completed`.
    ///     * For a task with an `action` of `review` this can be
    ///     `incomplete`, `approved`, or `rejected`.
    public init(message: String? = nil, resolutionState: UpdateTaskAssignmentByIdRequestBodyResolutionStateField? = nil) {
        self.message = message
        self.resolutionState = resolutionState
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        resolutionState = try container.decodeIfPresent(UpdateTaskAssignmentByIdRequestBodyResolutionStateField.self, forKey: .resolutionState)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(resolutionState, forKey: .resolutionState)
    }

}
