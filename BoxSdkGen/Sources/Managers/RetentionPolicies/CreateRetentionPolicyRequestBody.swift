import Foundation

public class CreateRetentionPolicyRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case policyName = "policy_name"
        case policyType = "policy_type"
        case dispositionAction = "disposition_action"
        case description
        case retentionLength = "retention_length"
        case retentionType = "retention_type"
        case canOwnerExtendRetention = "can_owner_extend_retention"
        case areOwnersNotified = "are_owners_notified"
        case customNotificationRecipients = "custom_notification_recipients"
    }

    /// The name for the retention policy
    public let policyName: String

    /// The type of the retention policy. A retention
    /// policy type can either be `finite`, where a
    /// specific amount of time to retain the content is known
    /// upfront, or `indefinite`, where the amount of time
    /// to retain the content is still unknown.
    public let policyType: CreateRetentionPolicyRequestBodyPolicyTypeField

    /// The disposition action of the retention policy.
    /// `permanently_delete` deletes the content
    /// retained by the policy permanently.
    /// `remove_retention` lifts retention policy
    /// from the content, allowing it to be deleted
    /// by users once the retention policy has expired.
    public let dispositionAction: CreateRetentionPolicyRequestBodyDispositionActionField

    /// The additional text description of the retention policy.
    public let description: String?

    /// The length of the retention policy. This value
    /// specifies the duration in days that the retention
    /// policy will be active for after being assigned to
    /// content.  If the policy has a `policy_type` of
    /// `indefinite`, the `retention_length` will also be
    /// `indefinite`.
    public let retentionLength: String?

    /// Specifies the retention type:
    /// 
    /// * `modifiable`: You can modify the retention policy. For example,
    /// you can add or remove folders, shorten or lengthen
    /// the policy duration, or delete the assignment.
    /// Use this type if your retention policy
    /// is not related to any regulatory purposes.
    /// 
    /// * `non_modifiable`: You can modify the retention policy
    /// only in a limited way: add a folder, lengthen the duration,
    /// retire the policy, change the disposition action
    /// or notification settings. You cannot perform other actions,
    /// such as deleting the assignment or shortening the
    /// policy duration. Use this type to ensure
    /// compliance with regulatory retention policies.
    public let retentionType: CreateRetentionPolicyRequestBodyRetentionTypeField?

    /// Whether the owner of a file will be allowed to
    /// extend the retention.
    public let canOwnerExtendRetention: Bool?

    /// Whether owner and co-owners of a file are notified
    /// when the policy nears expiration.
    public let areOwnersNotified: Bool?

    /// A list of users notified when
    /// the retention policy duration is about to end.
    public let customNotificationRecipients: [UserMini]?

    /// Initializer for a CreateRetentionPolicyRequestBody.
    ///
    /// - Parameters:
    ///   - policyName: The name for the retention policy
    ///   - policyType: The type of the retention policy. A retention
    ///     policy type can either be `finite`, where a
    ///     specific amount of time to retain the content is known
    ///     upfront, or `indefinite`, where the amount of time
    ///     to retain the content is still unknown.
    ///   - dispositionAction: The disposition action of the retention policy.
    ///     `permanently_delete` deletes the content
    ///     retained by the policy permanently.
    ///     `remove_retention` lifts retention policy
    ///     from the content, allowing it to be deleted
    ///     by users once the retention policy has expired.
    ///   - description: The additional text description of the retention policy.
    ///   - retentionLength: The length of the retention policy. This value
    ///     specifies the duration in days that the retention
    ///     policy will be active for after being assigned to
    ///     content.  If the policy has a `policy_type` of
    ///     `indefinite`, the `retention_length` will also be
    ///     `indefinite`.
    ///   - retentionType: Specifies the retention type:
    ///     
    ///     * `modifiable`: You can modify the retention policy. For example,
    ///     you can add or remove folders, shorten or lengthen
    ///     the policy duration, or delete the assignment.
    ///     Use this type if your retention policy
    ///     is not related to any regulatory purposes.
    ///     
    ///     * `non_modifiable`: You can modify the retention policy
    ///     only in a limited way: add a folder, lengthen the duration,
    ///     retire the policy, change the disposition action
    ///     or notification settings. You cannot perform other actions,
    ///     such as deleting the assignment or shortening the
    ///     policy duration. Use this type to ensure
    ///     compliance with regulatory retention policies.
    ///   - canOwnerExtendRetention: Whether the owner of a file will be allowed to
    ///     extend the retention.
    ///   - areOwnersNotified: Whether owner and co-owners of a file are notified
    ///     when the policy nears expiration.
    ///   - customNotificationRecipients: A list of users notified when
    ///     the retention policy duration is about to end.
    public init(policyName: String, policyType: CreateRetentionPolicyRequestBodyPolicyTypeField, dispositionAction: CreateRetentionPolicyRequestBodyDispositionActionField, description: String? = nil, retentionLength: String? = nil, retentionType: CreateRetentionPolicyRequestBodyRetentionTypeField? = nil, canOwnerExtendRetention: Bool? = nil, areOwnersNotified: Bool? = nil, customNotificationRecipients: [UserMini]? = nil) {
        self.policyName = policyName
        self.policyType = policyType
        self.dispositionAction = dispositionAction
        self.description = description
        self.retentionLength = retentionLength
        self.retentionType = retentionType
        self.canOwnerExtendRetention = canOwnerExtendRetention
        self.areOwnersNotified = areOwnersNotified
        self.customNotificationRecipients = customNotificationRecipients
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        policyName = try container.decode(String.self, forKey: .policyName)
        policyType = try container.decode(CreateRetentionPolicyRequestBodyPolicyTypeField.self, forKey: .policyType)
        dispositionAction = try container.decode(CreateRetentionPolicyRequestBodyDispositionActionField.self, forKey: .dispositionAction)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        retentionLength = try container.decodeIfPresent(String.self, forKey: .retentionLength)
        retentionType = try container.decodeIfPresent(CreateRetentionPolicyRequestBodyRetentionTypeField.self, forKey: .retentionType)
        canOwnerExtendRetention = try container.decodeIfPresent(Bool.self, forKey: .canOwnerExtendRetention)
        areOwnersNotified = try container.decodeIfPresent(Bool.self, forKey: .areOwnersNotified)
        customNotificationRecipients = try container.decodeIfPresent([UserMini].self, forKey: .customNotificationRecipients)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(policyName, forKey: .policyName)
        try container.encode(policyType, forKey: .policyType)
        try container.encode(dispositionAction, forKey: .dispositionAction)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(retentionLength, forKey: .retentionLength)
        try container.encodeIfPresent(retentionType, forKey: .retentionType)
        try container.encodeIfPresent(canOwnerExtendRetention, forKey: .canOwnerExtendRetention)
        try container.encodeIfPresent(areOwnersNotified, forKey: .areOwnersNotified)
        try container.encodeIfPresent(customNotificationRecipients, forKey: .customNotificationRecipients)
    }

}
