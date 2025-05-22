import Foundation

public class CreateTaskAssignmentRequestBodyTaskField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The ID of the task
    public let id: String

    /// The type of the item to assign.
    public let type: CreateTaskAssignmentRequestBodyTaskTypeField

    /// Initializer for a CreateTaskAssignmentRequestBodyTaskField.
    ///
    /// - Parameters:
    ///   - id: The ID of the task
    ///   - type: The type of the item to assign.
    public init(id: String, type: CreateTaskAssignmentRequestBodyTaskTypeField = CreateTaskAssignmentRequestBodyTaskTypeField.task) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(CreateTaskAssignmentRequestBodyTaskTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
