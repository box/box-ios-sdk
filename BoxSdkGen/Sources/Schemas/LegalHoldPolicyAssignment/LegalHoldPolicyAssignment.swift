import Foundation

/// Legal Hold Assignments are used to assign Legal Hold
/// Policies to Users, Folders, Files, or File Versions.
/// 
/// Creating a Legal Hold Assignment puts a hold
/// on the File-Versions that belong to the Assignment's
/// 'apply-to' entity.
public class LegalHoldPolicyAssignment: LegalHoldPolicyAssignmentBase {
    private enum CodingKeys: String, CodingKey {
        case legalHoldPolicy = "legal_hold_policy"
        case assignedTo = "assigned_to"
        case assignedBy = "assigned_by"
        case assignedAt = "assigned_at"
        case deletedAt = "deleted_at"
    }

    public let legalHoldPolicy: LegalHoldPolicyMini?

    public let assignedTo: FileOrFolderOrWebLink?

    public let assignedBy: UserMini?

    /// When the legal hold policy assignment object was
    /// created
    public let assignedAt: Date?

    /// When the assignment release request was sent.
    /// (Because it can take time for an assignment to fully
    /// delete, this isn't quite the same time that the
    /// assignment is fully deleted). If null, Assignment
    /// was not deleted.
    public let deletedAt: Date?

    /// Initializer for a LegalHoldPolicyAssignment.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this legal hold assignment
    ///   - type: `legal_hold_policy_assignment`
    ///   - legalHoldPolicy: 
    ///   - assignedTo: 
    ///   - assignedBy: 
    ///   - assignedAt: When the legal hold policy assignment object was
    ///     created
    ///   - deletedAt: When the assignment release request was sent.
    ///     (Because it can take time for an assignment to fully
    ///     delete, this isn't quite the same time that the
    ///     assignment is fully deleted). If null, Assignment
    ///     was not deleted.
    public init(id: String? = nil, type: LegalHoldPolicyAssignmentBaseTypeField? = nil, legalHoldPolicy: LegalHoldPolicyMini? = nil, assignedTo: FileOrFolderOrWebLink? = nil, assignedBy: UserMini? = nil, assignedAt: Date? = nil, deletedAt: Date? = nil) {
        self.legalHoldPolicy = legalHoldPolicy
        self.assignedTo = assignedTo
        self.assignedBy = assignedBy
        self.assignedAt = assignedAt
        self.deletedAt = deletedAt

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        legalHoldPolicy = try container.decodeIfPresent(LegalHoldPolicyMini.self, forKey: .legalHoldPolicy)
        assignedTo = try container.decodeIfPresent(FileOrFolderOrWebLink.self, forKey: .assignedTo)
        assignedBy = try container.decodeIfPresent(UserMini.self, forKey: .assignedBy)
        assignedAt = try container.decodeDateTimeIfPresent(forKey: .assignedAt)
        deletedAt = try container.decodeDateTimeIfPresent(forKey: .deletedAt)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(legalHoldPolicy, forKey: .legalHoldPolicy)
        try container.encodeIfPresent(assignedTo, forKey: .assignedTo)
        try container.encodeIfPresent(assignedBy, forKey: .assignedBy)
        try container.encodeDateTimeIfPresent(field: assignedAt, forKey: .assignedAt)
        try container.encodeDateTimeIfPresent(field: deletedAt, forKey: .deletedAt)
        try super.encode(to: encoder)
    }

}
