import Foundation

public class CreateTaskAssignmentRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case task
        case assignTo = "assign_to"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The task to assign to a user.
    public let task: CreateTaskAssignmentRequestBodyTaskField

    /// The user to assign the task to.
    public let assignTo: CreateTaskAssignmentRequestBodyAssignToField

    /// Initializer for a CreateTaskAssignmentRequestBody.
    ///
    /// - Parameters:
    ///   - task: The task to assign to a user.
    ///   - assignTo: The user to assign the task to.
    public init(task: CreateTaskAssignmentRequestBodyTaskField, assignTo: CreateTaskAssignmentRequestBodyAssignToField) {
        self.task = task
        self.assignTo = assignTo
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        task = try container.decode(CreateTaskAssignmentRequestBodyTaskField.self, forKey: .task)
        assignTo = try container.decode(CreateTaskAssignmentRequestBodyAssignToField.self, forKey: .assignTo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(task, forKey: .task)
        try container.encode(assignTo, forKey: .assignTo)
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
