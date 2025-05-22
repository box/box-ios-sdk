import Foundation

public class UpdateStoragePolicyAssignmentByIdRequestBodyStoragePolicyField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The ID of the storage policy to assign.
    public let id: String

    /// The type to assign.
    public let type: UpdateStoragePolicyAssignmentByIdRequestBodyStoragePolicyTypeField

    /// Initializer for a UpdateStoragePolicyAssignmentByIdRequestBodyStoragePolicyField.
    ///
    /// - Parameters:
    ///   - id: The ID of the storage policy to assign.
    ///   - type: The type to assign.
    public init(id: String, type: UpdateStoragePolicyAssignmentByIdRequestBodyStoragePolicyTypeField = UpdateStoragePolicyAssignmentByIdRequestBodyStoragePolicyTypeField.storagePolicy) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(UpdateStoragePolicyAssignmentByIdRequestBodyStoragePolicyTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
