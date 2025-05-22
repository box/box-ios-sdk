import Foundation

public class CreateStoragePolicyAssignmentRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case storagePolicy = "storage_policy"
        case assignedTo = "assigned_to"
    }

    /// The storage policy to assign to the user or
    /// enterprise
    public let storagePolicy: CreateStoragePolicyAssignmentRequestBodyStoragePolicyField

    /// The user or enterprise to assign the storage
    /// policy to.
    public let assignedTo: CreateStoragePolicyAssignmentRequestBodyAssignedToField

    /// Initializer for a CreateStoragePolicyAssignmentRequestBody.
    ///
    /// - Parameters:
    ///   - storagePolicy: The storage policy to assign to the user or
    ///     enterprise
    ///   - assignedTo: The user or enterprise to assign the storage
    ///     policy to.
    public init(storagePolicy: CreateStoragePolicyAssignmentRequestBodyStoragePolicyField, assignedTo: CreateStoragePolicyAssignmentRequestBodyAssignedToField) {
        self.storagePolicy = storagePolicy
        self.assignedTo = assignedTo
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        storagePolicy = try container.decode(CreateStoragePolicyAssignmentRequestBodyStoragePolicyField.self, forKey: .storagePolicy)
        assignedTo = try container.decode(CreateStoragePolicyAssignmentRequestBodyAssignedToField.self, forKey: .assignedTo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(storagePolicy, forKey: .storagePolicy)
        try container.encode(assignedTo, forKey: .assignedTo)
    }

}
