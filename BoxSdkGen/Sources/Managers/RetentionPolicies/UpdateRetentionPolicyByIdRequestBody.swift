import Foundation

public class UpdateRetentionPolicyByIdRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case policyName = "policy_name"
        case description
        case dispositionAction = "disposition_action"
        case retentionType = "retention_type"
        case retentionLength = "retention_length"
        case status
        case canOwnerExtendRetention = "can_owner_extend_retention"
        case areOwnersNotified = "are_owners_notified"
        case customNotificationRecipients = "custom_notification_recipients"
    }

    /// The name for the retention policy
    @CodableTriState public private(set) var policyName: String?

    /// The additional text description of the retention policy.
    @CodableTriState public private(set) var description: String?

    /// The disposition action of the retention policy.
    /// This action can be `permanently_delete`, which
    /// will cause the content retained by the policy
    /// to be permanently deleted, or `remove_retention`,
    /// which will lift the retention policy from the content,
    /// allowing it to be deleted by users,
    /// once the retention policy has expired.
    /// You can use `null` if you don't want to change `disposition_action`.
    public let dispositionAction: String?

    /// Specifies the retention type:
    /// 
    /// * `modifiable`: You can modify the retention policy. For example,
    /// you can add or remove folders, shorten or lengthen
    /// the policy duration, or delete the assignment.
    /// Use this type if your retention policy
    /// is not related to any regulatory purposes.
    /// * `non-modifiable`: You can modify the retention policy
    /// only in a limited way: add a folder, lengthen the duration,
    /// retire the policy, change the disposition action
    /// or notification settings. You cannot perform other actions,
    /// such as deleting the assignment or shortening the
    /// policy duration. Use this type to ensure
    /// compliance with regulatory retention policies.
    /// 
    /// When updating a retention policy, you can use
    /// `non-modifiable` type only. You can convert a
    /// `modifiable` policy to `non-modifiable`, but
    /// not the other way around.
    @CodableTriState public private(set) var retentionType: String?

    /// The length of the retention policy. This value
    /// specifies the duration in days that the retention
    /// policy will be active for after being assigned to
    /// content.  If the policy has a `policy_type` of
    /// `indefinite`, the `retention_length` will also be
    /// `indefinite`.
    public let retentionLength: String?

    /// Used to retire a retention policy.
    /// 
    /// If not retiring a policy, do not include this parameter
    /// or set it to `null`.
    @CodableTriState public private(set) var status: String?

    /// Determines if the owner of items under the policy
    /// can extend the retention when the original retention
    /// duration is about to end.
    @CodableTriState public private(set) var canOwnerExtendRetention: Bool?

    /// Determines if owners and co-owners of items
    /// under the policy are notified when
    /// the retention duration is about to end.
    @CodableTriState public private(set) var areOwnersNotified: Bool?

    /// A list of users notified when the retention duration is about to end.
    @CodableTriState public private(set) var customNotificationRecipients: [UserBase]?

    /// Initializer for a UpdateRetentionPolicyByIdRequestBody.
    ///
    /// - Parameters:
    ///   - policyName: The name for the retention policy
    ///   - description: The additional text description of the retention policy.
    ///   - dispositionAction: The disposition action of the retention policy.
    ///     This action can be `permanently_delete`, which
    ///     will cause the content retained by the policy
    ///     to be permanently deleted, or `remove_retention`,
    ///     which will lift the retention policy from the content,
    ///     allowing it to be deleted by users,
    ///     once the retention policy has expired.
    ///     You can use `null` if you don't want to change `disposition_action`.
    ///   - retentionType: Specifies the retention type:
    ///     
    ///     * `modifiable`: You can modify the retention policy. For example,
    ///     you can add or remove folders, shorten or lengthen
    ///     the policy duration, or delete the assignment.
    ///     Use this type if your retention policy
    ///     is not related to any regulatory purposes.
    ///     * `non-modifiable`: You can modify the retention policy
    ///     only in a limited way: add a folder, lengthen the duration,
    ///     retire the policy, change the disposition action
    ///     or notification settings. You cannot perform other actions,
    ///     such as deleting the assignment or shortening the
    ///     policy duration. Use this type to ensure
    ///     compliance with regulatory retention policies.
    ///     
    ///     When updating a retention policy, you can use
    ///     `non-modifiable` type only. You can convert a
    ///     `modifiable` policy to `non-modifiable`, but
    ///     not the other way around.
    ///   - retentionLength: The length of the retention policy. This value
    ///     specifies the duration in days that the retention
    ///     policy will be active for after being assigned to
    ///     content.  If the policy has a `policy_type` of
    ///     `indefinite`, the `retention_length` will also be
    ///     `indefinite`.
    ///   - status: Used to retire a retention policy.
    ///     
    ///     If not retiring a policy, do not include this parameter
    ///     or set it to `null`.
    ///   - canOwnerExtendRetention: Determines if the owner of items under the policy
    ///     can extend the retention when the original retention
    ///     duration is about to end.
    ///   - areOwnersNotified: Determines if owners and co-owners of items
    ///     under the policy are notified when
    ///     the retention duration is about to end.
    ///   - customNotificationRecipients: A list of users notified when the retention duration is about to end.
    public init(policyName: TriStateField<String> = nil, description: TriStateField<String> = nil, dispositionAction: String? = nil, retentionType: TriStateField<String> = nil, retentionLength: String? = nil, status: TriStateField<String> = nil, canOwnerExtendRetention: TriStateField<Bool> = nil, areOwnersNotified: TriStateField<Bool> = nil, customNotificationRecipients: TriStateField<[UserBase]> = nil) {
        self._policyName = CodableTriState(state: policyName)
        self._description = CodableTriState(state: description)
        self.dispositionAction = dispositionAction
        self._retentionType = CodableTriState(state: retentionType)
        self.retentionLength = retentionLength
        self._status = CodableTriState(state: status)
        self._canOwnerExtendRetention = CodableTriState(state: canOwnerExtendRetention)
        self._areOwnersNotified = CodableTriState(state: areOwnersNotified)
        self._customNotificationRecipients = CodableTriState(state: customNotificationRecipients)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        policyName = try container.decodeIfPresent(String.self, forKey: .policyName)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        dispositionAction = try container.decodeIfPresent(String.self, forKey: .dispositionAction)
        retentionType = try container.decodeIfPresent(String.self, forKey: .retentionType)
        retentionLength = try container.decodeIfPresent(String.self, forKey: .retentionLength)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        canOwnerExtendRetention = try container.decodeIfPresent(Bool.self, forKey: .canOwnerExtendRetention)
        areOwnersNotified = try container.decodeIfPresent(Bool.self, forKey: .areOwnersNotified)
        customNotificationRecipients = try container.decodeIfPresent([UserBase].self, forKey: .customNotificationRecipients)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _policyName.state, forKey: .policyName)
        try container.encode(field: _description.state, forKey: .description)
        try container.encodeIfPresent(dispositionAction, forKey: .dispositionAction)
        try container.encode(field: _retentionType.state, forKey: .retentionType)
        try container.encodeIfPresent(retentionLength, forKey: .retentionLength)
        try container.encode(field: _status.state, forKey: .status)
        try container.encode(field: _canOwnerExtendRetention.state, forKey: .canOwnerExtendRetention)
        try container.encode(field: _areOwnersNotified.state, forKey: .areOwnersNotified)
        try container.encode(field: _customNotificationRecipients.state, forKey: .customNotificationRecipients)
    }

}
