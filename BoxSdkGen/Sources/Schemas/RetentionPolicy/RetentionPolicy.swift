import Foundation

/// A retention policy blocks permanent deletion of content
/// for a specified amount of time. Admins can create retention
/// policies and then later assign them to specific folders, metadata
/// templates, or their entire enterprise.  To use this feature, you must
/// have the manage retention policies scope enabled
/// for your API key via your application management console.
public class RetentionPolicy: RetentionPolicyMini {
    private enum CodingKeys: String, CodingKey {
        case description
        case policyType = "policy_type"
        case retentionType = "retention_type"
        case status
        case createdBy = "created_by"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case canOwnerExtendRetention = "can_owner_extend_retention"
        case areOwnersNotified = "are_owners_notified"
        case customNotificationRecipients = "custom_notification_recipients"
        case assignmentCounts = "assignment_counts"
    }

    /// The additional text description of the retention policy.
    public let description: String?

    /// The type of the retention policy. A retention
    /// policy type can either be `finite`, where a
    /// specific amount of time to retain the content is known
    /// upfront, or `indefinite`, where the amount of time
    /// to retain the content is still unknown.
    public let policyType: RetentionPolicyPolicyTypeField?

    /// Specifies the retention type:
    /// 
    /// * `modifiable`: You can modify the retention policy. For example,
    ///  you can add or remove folders, shorten or lengthen
    ///  the policy duration, or delete the assignment.
    ///  Use this type if your retention policy
    ///  is not related to any regulatory purposes.
    /// 
    /// * `non-modifiable`: You can modify the retention policy
    ///  only in a limited way: add a folder, lengthen the duration,
    ///  retire the policy, change the disposition action
    ///  or notification settings. You cannot perform other actions,
    ///  such as deleting the assignment or shortening the
    ///  policy duration. Use this type to ensure
    ///  compliance with regulatory retention policies.
    public let retentionType: RetentionPolicyRetentionTypeField?

    /// The status of the retention policy. The status of
    /// a policy will be `active`, unless explicitly retired by an
    /// administrator, in which case the status will be `retired`.
    /// Once a policy has been retired, it cannot become
    /// active again.
    public let status: RetentionPolicyStatusField?

    public let createdBy: UserMini?

    /// When the retention policy object was created.
    public let createdAt: Date?

    /// When the retention policy object was last modified.
    public let modifiedAt: Date?

    /// Determines if the owner of items under the policy
    /// can extend the retention when the original
    /// retention duration is about to end.
    public let canOwnerExtendRetention: Bool?

    /// Determines if owners and co-owners of items
    /// under the policy are notified when
    /// the retention duration is about to end.
    public let areOwnersNotified: Bool?

    /// A list of users notified when the retention policy duration is about to end.
    public let customNotificationRecipients: [UserMini]?

    /// Counts the retention policy assignments for each item type.
    public let assignmentCounts: RetentionPolicyAssignmentCountsField?

    /// Initializer for a RetentionPolicy.
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
    ///   - description: The additional text description of the retention policy.
    ///   - policyType: The type of the retention policy. A retention
    ///     policy type can either be `finite`, where a
    ///     specific amount of time to retain the content is known
    ///     upfront, or `indefinite`, where the amount of time
    ///     to retain the content is still unknown.
    ///   - retentionType: Specifies the retention type:
    ///     
    ///     * `modifiable`: You can modify the retention policy. For example,
    ///      you can add or remove folders, shorten or lengthen
    ///      the policy duration, or delete the assignment.
    ///      Use this type if your retention policy
    ///      is not related to any regulatory purposes.
    ///     
    ///     * `non-modifiable`: You can modify the retention policy
    ///      only in a limited way: add a folder, lengthen the duration,
    ///      retire the policy, change the disposition action
    ///      or notification settings. You cannot perform other actions,
    ///      such as deleting the assignment or shortening the
    ///      policy duration. Use this type to ensure
    ///      compliance with regulatory retention policies.
    ///   - status: The status of the retention policy. The status of
    ///     a policy will be `active`, unless explicitly retired by an
    ///     administrator, in which case the status will be `retired`.
    ///     Once a policy has been retired, it cannot become
    ///     active again.
    ///   - createdBy: 
    ///   - createdAt: When the retention policy object was created.
    ///   - modifiedAt: When the retention policy object was last modified.
    ///   - canOwnerExtendRetention: Determines if the owner of items under the policy
    ///     can extend the retention when the original
    ///     retention duration is about to end.
    ///   - areOwnersNotified: Determines if owners and co-owners of items
    ///     under the policy are notified when
    ///     the retention duration is about to end.
    ///   - customNotificationRecipients: A list of users notified when the retention policy duration is about to end.
    ///   - assignmentCounts: Counts the retention policy assignments for each item type.
    public init(id: String, type: RetentionPolicyBaseTypeField = RetentionPolicyBaseTypeField.retentionPolicy, policyName: String? = nil, retentionLength: String? = nil, dispositionAction: RetentionPolicyMiniDispositionActionField? = nil, description: String? = nil, policyType: RetentionPolicyPolicyTypeField? = nil, retentionType: RetentionPolicyRetentionTypeField? = nil, status: RetentionPolicyStatusField? = nil, createdBy: UserMini? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, canOwnerExtendRetention: Bool? = nil, areOwnersNotified: Bool? = nil, customNotificationRecipients: [UserMini]? = nil, assignmentCounts: RetentionPolicyAssignmentCountsField? = nil) {
        self.description = description
        self.policyType = policyType
        self.retentionType = retentionType
        self.status = status
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.canOwnerExtendRetention = canOwnerExtendRetention
        self.areOwnersNotified = areOwnersNotified
        self.customNotificationRecipients = customNotificationRecipients
        self.assignmentCounts = assignmentCounts

        super.init(id: id, type: type, policyName: policyName, retentionLength: retentionLength, dispositionAction: dispositionAction)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        policyType = try container.decodeIfPresent(RetentionPolicyPolicyTypeField.self, forKey: .policyType)
        retentionType = try container.decodeIfPresent(RetentionPolicyRetentionTypeField.self, forKey: .retentionType)
        status = try container.decodeIfPresent(RetentionPolicyStatusField.self, forKey: .status)
        createdBy = try container.decodeIfPresent(UserMini.self, forKey: .createdBy)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
        canOwnerExtendRetention = try container.decodeIfPresent(Bool.self, forKey: .canOwnerExtendRetention)
        areOwnersNotified = try container.decodeIfPresent(Bool.self, forKey: .areOwnersNotified)
        customNotificationRecipients = try container.decodeIfPresent([UserMini].self, forKey: .customNotificationRecipients)
        assignmentCounts = try container.decodeIfPresent(RetentionPolicyAssignmentCountsField.self, forKey: .assignmentCounts)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(policyType, forKey: .policyType)
        try container.encodeIfPresent(retentionType, forKey: .retentionType)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
        try container.encodeIfPresent(canOwnerExtendRetention, forKey: .canOwnerExtendRetention)
        try container.encodeIfPresent(areOwnersNotified, forKey: .areOwnersNotified)
        try container.encodeIfPresent(customNotificationRecipients, forKey: .customNotificationRecipients)
        try container.encodeIfPresent(assignmentCounts, forKey: .assignmentCounts)
        try super.encode(to: encoder)
    }

}
