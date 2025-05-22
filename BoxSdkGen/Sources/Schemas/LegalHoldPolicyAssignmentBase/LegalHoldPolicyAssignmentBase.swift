import Foundation

/// Legal Hold Assignments are used to assign Legal Hold
/// Policies to Users, Folders, Files, or File Versions.
/// 
/// Creating a Legal Hold Assignment puts a hold
/// on the File-Versions that belong to the Assignment's
/// 'apply-to' entity.
public class LegalHoldPolicyAssignmentBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier for this legal hold assignment
    public let id: String?

    /// `legal_hold_policy_assignment`
    public let type: LegalHoldPolicyAssignmentBaseTypeField?

    /// Initializer for a LegalHoldPolicyAssignmentBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this legal hold assignment
    ///   - type: `legal_hold_policy_assignment`
    public init(id: String? = nil, type: LegalHoldPolicyAssignmentBaseTypeField? = nil) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(LegalHoldPolicyAssignmentBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
    }

}
