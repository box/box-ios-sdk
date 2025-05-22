import Foundation

/// A base representation of a retention policy assignment.
public class RetentionPolicyAssignmentBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier that represents a file version.
    public let id: String

    /// `retention_policy_assignment`
    public let type: RetentionPolicyAssignmentBaseTypeField

    /// Initializer for a RetentionPolicyAssignmentBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represents a file version.
    ///   - type: `retention_policy_assignment`
    public init(id: String, type: RetentionPolicyAssignmentBaseTypeField = RetentionPolicyAssignmentBaseTypeField.retentionPolicyAssignment) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(RetentionPolicyAssignmentBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
