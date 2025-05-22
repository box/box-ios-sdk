import Foundation

public class CreateStoragePolicyAssignmentRequestBodyStoragePolicyField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The ID of the storage policy to assign.
    public let id: String

    /// The type to assign.
    public let type: CreateStoragePolicyAssignmentRequestBodyStoragePolicyTypeField

    /// Initializer for a CreateStoragePolicyAssignmentRequestBodyStoragePolicyField.
    ///
    /// - Parameters:
    ///   - id: The ID of the storage policy to assign.
    ///   - type: The type to assign.
    public init(id: String, type: CreateStoragePolicyAssignmentRequestBodyStoragePolicyTypeField = CreateStoragePolicyAssignmentRequestBodyStoragePolicyTypeField.storagePolicy) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(CreateStoragePolicyAssignmentRequestBodyStoragePolicyTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
