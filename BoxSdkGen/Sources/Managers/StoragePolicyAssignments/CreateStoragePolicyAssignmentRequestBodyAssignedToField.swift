import Foundation

public class CreateStoragePolicyAssignmentRequestBodyAssignedToField: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
    }

    /// The type to assign the policy to.
    public let type: CreateStoragePolicyAssignmentRequestBodyAssignedToTypeField

    /// The ID of the user or enterprise
    public let id: String

    /// Initializer for a CreateStoragePolicyAssignmentRequestBodyAssignedToField.
    ///
    /// - Parameters:
    ///   - type: The type to assign the policy to.
    ///   - id: The ID of the user or enterprise
    public init(type: CreateStoragePolicyAssignmentRequestBodyAssignedToTypeField, id: String) {
        self.type = type
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(CreateStoragePolicyAssignmentRequestBodyAssignedToTypeField.self, forKey: .type)
        id = try container.decode(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
    }

}
