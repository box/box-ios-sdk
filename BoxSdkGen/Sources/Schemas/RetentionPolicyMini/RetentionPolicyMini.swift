import Foundation

/// A mini representation of a retention policy, used when
/// nested within another resource.
public class RetentionPolicyMini: RetentionPolicyBase {
    private enum CodingKeys: String, CodingKey {
        case policyName = "policy_name"
        case retentionLength = "retention_length"
        case dispositionAction = "disposition_action"
    }

    /// The name given to the retention policy.
    public let policyName: String?

    /// The length of the retention policy. This value
    /// specifies the duration in days that the retention
    /// policy will be active for after being assigned to
    /// content.  If the policy has a `policy_type` of
    /// `indefinite`, the `retention_length` will also be
    /// `indefinite`.
    public let retentionLength: String?

    /// The disposition action of the retention policy.
    /// This action can be `permanently_delete`, which
    /// will cause the content retained by the policy
    /// to be permanently deleted, or `remove_retention`,
    /// which will lift the retention policy from the content,
    /// allowing it to be deleted by users,
    /// once the retention policy has expired.
    public let dispositionAction: RetentionPolicyMiniDispositionActionField?

    /// Initializer for a RetentionPolicyMini.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represents a retention policy.
    ///   - type: `retention_policy`
    ///   - policyName: The name given to the retention policy.
    ///   - retentionLength: The length of the retention policy. This value
    ///     specifies the duration in days that the retention
    ///     policy will be active for after being assigned to
    ///     content.  If the policy has a `policy_type` of
    ///     `indefinite`, the `retention_length` will also be
    ///     `indefinite`.
    ///   - dispositionAction: The disposition action of the retention policy.
    ///     This action can be `permanently_delete`, which
    ///     will cause the content retained by the policy
    ///     to be permanently deleted, or `remove_retention`,
    ///     which will lift the retention policy from the content,
    ///     allowing it to be deleted by users,
    ///     once the retention policy has expired.
    public init(id: String, type: RetentionPolicyBaseTypeField = RetentionPolicyBaseTypeField.retentionPolicy, policyName: String? = nil, retentionLength: String? = nil, dispositionAction: RetentionPolicyMiniDispositionActionField? = nil) {
        self.policyName = policyName
        self.retentionLength = retentionLength
        self.dispositionAction = dispositionAction

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        policyName = try container.decodeIfPresent(String.self, forKey: .policyName)
        retentionLength = try container.decodeIfPresent(String.self, forKey: .retentionLength)
        dispositionAction = try container.decodeIfPresent(RetentionPolicyMiniDispositionActionField.self, forKey: .dispositionAction)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(policyName, forKey: .policyName)
        try container.encodeIfPresent(retentionLength, forKey: .retentionLength)
        try container.encodeIfPresent(dispositionAction, forKey: .dispositionAction)
        try super.encode(to: encoder)
    }

}
