import Foundation

public class UpdateStoragePolicyAssignmentByIdRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case storagePolicy = "storage_policy"
    }

    /// The storage policy to assign to the user or
    /// enterprise
    public let storagePolicy: UpdateStoragePolicyAssignmentByIdRequestBodyStoragePolicyField

    /// Initializer for a UpdateStoragePolicyAssignmentByIdRequestBody.
    ///
    /// - Parameters:
    ///   - storagePolicy: The storage policy to assign to the user or
    ///     enterprise
    public init(storagePolicy: UpdateStoragePolicyAssignmentByIdRequestBodyStoragePolicyField) {
        self.storagePolicy = storagePolicy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        storagePolicy = try container.decode(UpdateStoragePolicyAssignmentByIdRequestBodyStoragePolicyField.self, forKey: .storagePolicy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(storagePolicy, forKey: .storagePolicy)
    }

}
