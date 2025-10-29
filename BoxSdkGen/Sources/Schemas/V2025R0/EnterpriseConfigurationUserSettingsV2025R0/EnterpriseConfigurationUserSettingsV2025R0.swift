import Foundation

/// The enterprise configuration for the user settings category.
public class EnterpriseConfigurationUserSettingsV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case enterpriseFeatureSettings = "enterprise_feature_settings"
        case userInvitesExpirationTimeFrame = "user_invites_expiration_time_frame"
        case isUsernameChangeRestricted = "is_username_change_restricted"
        case isBoxSyncRestrictedForNewUsers = "is_box_sync_restricted_for_new_users"
        case isViewAllUsersEnabledForNewUsers = "is_view_all_users_enabled_for_new_users"
        case isDeviceLimitExemptionEnabledForNewUsers = "is_device_limit_exemption_enabled_for_new_users"
        case isExternalCollaborationRestrictedForNewUsers = "is_external_collaboration_restricted_for_new_users"
        case isUnlimitedStorageEnabledForNewUsers = "is_unlimited_storage_enabled_for_new_users"
        case newUserDefaultStorageLimit = "new_user_default_storage_limit"
        case newUserDefaultTimezone = "new_user_default_timezone"
        case newUserDefaultLanguage = "new_user_default_language"
        case isEnterpriseSsoRequired = "is_enterprise_sso_required"
        case isEnterpriseSsoInTesting = "is_enterprise_sso_in_testing"
        case isSsoAutoAddGroupsEnabled = "is_sso_auto_add_groups_enabled"
        case isSsoAutoAddUserToGroupsEnabled = "is_sso_auto_add_user_to_groups_enabled"
        case isSsoAutoRemoveUserFromGroupsEnabled = "is_sso_auto_remove_user_from_groups_enabled"
        case userTrackingCodes = "user_tracking_codes"
        case numberOfUserTrackingCodesRemaining = "number_of_user_tracking_codes_remaining"
        case isInstantLoginRestricted = "is_instant_login_restricted"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    public let enterpriseFeatureSettings: [EnterpriseFeatureSettingsItemV2025R0]?

    public let userInvitesExpirationTimeFrame: EnterpriseConfigurationItemStringV2025R0?

    public let isUsernameChangeRestricted: EnterpriseConfigurationItemBooleanV2025R0?

    public let isBoxSyncRestrictedForNewUsers: EnterpriseConfigurationItemBooleanV2025R0?

    public let isViewAllUsersEnabledForNewUsers: EnterpriseConfigurationItemBooleanV2025R0?

    public let isDeviceLimitExemptionEnabledForNewUsers: EnterpriseConfigurationItemBooleanV2025R0?

    public let isExternalCollaborationRestrictedForNewUsers: EnterpriseConfigurationItemBooleanV2025R0?

    public let isUnlimitedStorageEnabledForNewUsers: EnterpriseConfigurationItemBooleanV2025R0?

    public let newUserDefaultStorageLimit: EnterpriseConfigurationItemIntegerV2025R0?

    public let newUserDefaultTimezone: EnterpriseConfigurationItemStringV2025R0?

    public let newUserDefaultLanguage: EnterpriseConfigurationItemStringV2025R0?

    public let isEnterpriseSsoRequired: EnterpriseConfigurationItemBooleanV2025R0?

    public let isEnterpriseSsoInTesting: EnterpriseConfigurationItemBooleanV2025R0?

    public let isSsoAutoAddGroupsEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isSsoAutoAddUserToGroupsEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isSsoAutoRemoveUserFromGroupsEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let userTrackingCodes: EnterpriseConfigurationUserSettingsV2025R0UserTrackingCodesField?

    public let numberOfUserTrackingCodesRemaining: EnterpriseConfigurationItemIntegerV2025R0?

    public let isInstantLoginRestricted: EnterpriseConfigurationItemBooleanV2025R0?

    public init(enterpriseFeatureSettings: [EnterpriseFeatureSettingsItemV2025R0]? = nil, userInvitesExpirationTimeFrame: EnterpriseConfigurationItemStringV2025R0? = nil, isUsernameChangeRestricted: EnterpriseConfigurationItemBooleanV2025R0? = nil, isBoxSyncRestrictedForNewUsers: EnterpriseConfigurationItemBooleanV2025R0? = nil, isViewAllUsersEnabledForNewUsers: EnterpriseConfigurationItemBooleanV2025R0? = nil, isDeviceLimitExemptionEnabledForNewUsers: EnterpriseConfigurationItemBooleanV2025R0? = nil, isExternalCollaborationRestrictedForNewUsers: EnterpriseConfigurationItemBooleanV2025R0? = nil, isUnlimitedStorageEnabledForNewUsers: EnterpriseConfigurationItemBooleanV2025R0? = nil, newUserDefaultStorageLimit: EnterpriseConfigurationItemIntegerV2025R0? = nil, newUserDefaultTimezone: EnterpriseConfigurationItemStringV2025R0? = nil, newUserDefaultLanguage: EnterpriseConfigurationItemStringV2025R0? = nil, isEnterpriseSsoRequired: EnterpriseConfigurationItemBooleanV2025R0? = nil, isEnterpriseSsoInTesting: EnterpriseConfigurationItemBooleanV2025R0? = nil, isSsoAutoAddGroupsEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isSsoAutoAddUserToGroupsEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isSsoAutoRemoveUserFromGroupsEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, userTrackingCodes: EnterpriseConfigurationUserSettingsV2025R0UserTrackingCodesField? = nil, numberOfUserTrackingCodesRemaining: EnterpriseConfigurationItemIntegerV2025R0? = nil, isInstantLoginRestricted: EnterpriseConfigurationItemBooleanV2025R0? = nil) {
        self.enterpriseFeatureSettings = enterpriseFeatureSettings
        self.userInvitesExpirationTimeFrame = userInvitesExpirationTimeFrame
        self.isUsernameChangeRestricted = isUsernameChangeRestricted
        self.isBoxSyncRestrictedForNewUsers = isBoxSyncRestrictedForNewUsers
        self.isViewAllUsersEnabledForNewUsers = isViewAllUsersEnabledForNewUsers
        self.isDeviceLimitExemptionEnabledForNewUsers = isDeviceLimitExemptionEnabledForNewUsers
        self.isExternalCollaborationRestrictedForNewUsers = isExternalCollaborationRestrictedForNewUsers
        self.isUnlimitedStorageEnabledForNewUsers = isUnlimitedStorageEnabledForNewUsers
        self.newUserDefaultStorageLimit = newUserDefaultStorageLimit
        self.newUserDefaultTimezone = newUserDefaultTimezone
        self.newUserDefaultLanguage = newUserDefaultLanguage
        self.isEnterpriseSsoRequired = isEnterpriseSsoRequired
        self.isEnterpriseSsoInTesting = isEnterpriseSsoInTesting
        self.isSsoAutoAddGroupsEnabled = isSsoAutoAddGroupsEnabled
        self.isSsoAutoAddUserToGroupsEnabled = isSsoAutoAddUserToGroupsEnabled
        self.isSsoAutoRemoveUserFromGroupsEnabled = isSsoAutoRemoveUserFromGroupsEnabled
        self.userTrackingCodes = userTrackingCodes
        self.numberOfUserTrackingCodesRemaining = numberOfUserTrackingCodesRemaining
        self.isInstantLoginRestricted = isInstantLoginRestricted
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        enterpriseFeatureSettings = try container.decodeIfPresent([EnterpriseFeatureSettingsItemV2025R0].self, forKey: .enterpriseFeatureSettings)
        userInvitesExpirationTimeFrame = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .userInvitesExpirationTimeFrame)
        isUsernameChangeRestricted = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isUsernameChangeRestricted)
        isBoxSyncRestrictedForNewUsers = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isBoxSyncRestrictedForNewUsers)
        isViewAllUsersEnabledForNewUsers = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isViewAllUsersEnabledForNewUsers)
        isDeviceLimitExemptionEnabledForNewUsers = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isDeviceLimitExemptionEnabledForNewUsers)
        isExternalCollaborationRestrictedForNewUsers = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isExternalCollaborationRestrictedForNewUsers)
        isUnlimitedStorageEnabledForNewUsers = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isUnlimitedStorageEnabledForNewUsers)
        newUserDefaultStorageLimit = try container.decodeIfPresent(EnterpriseConfigurationItemIntegerV2025R0.self, forKey: .newUserDefaultStorageLimit)
        newUserDefaultTimezone = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .newUserDefaultTimezone)
        newUserDefaultLanguage = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .newUserDefaultLanguage)
        isEnterpriseSsoRequired = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isEnterpriseSsoRequired)
        isEnterpriseSsoInTesting = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isEnterpriseSsoInTesting)
        isSsoAutoAddGroupsEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isSsoAutoAddGroupsEnabled)
        isSsoAutoAddUserToGroupsEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isSsoAutoAddUserToGroupsEnabled)
        isSsoAutoRemoveUserFromGroupsEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isSsoAutoRemoveUserFromGroupsEnabled)
        userTrackingCodes = try container.decodeIfPresent(EnterpriseConfigurationUserSettingsV2025R0UserTrackingCodesField.self, forKey: .userTrackingCodes)
        numberOfUserTrackingCodesRemaining = try container.decodeIfPresent(EnterpriseConfigurationItemIntegerV2025R0.self, forKey: .numberOfUserTrackingCodesRemaining)
        isInstantLoginRestricted = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isInstantLoginRestricted)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(enterpriseFeatureSettings, forKey: .enterpriseFeatureSettings)
        try container.encodeIfPresent(userInvitesExpirationTimeFrame, forKey: .userInvitesExpirationTimeFrame)
        try container.encodeIfPresent(isUsernameChangeRestricted, forKey: .isUsernameChangeRestricted)
        try container.encodeIfPresent(isBoxSyncRestrictedForNewUsers, forKey: .isBoxSyncRestrictedForNewUsers)
        try container.encodeIfPresent(isViewAllUsersEnabledForNewUsers, forKey: .isViewAllUsersEnabledForNewUsers)
        try container.encodeIfPresent(isDeviceLimitExemptionEnabledForNewUsers, forKey: .isDeviceLimitExemptionEnabledForNewUsers)
        try container.encodeIfPresent(isExternalCollaborationRestrictedForNewUsers, forKey: .isExternalCollaborationRestrictedForNewUsers)
        try container.encodeIfPresent(isUnlimitedStorageEnabledForNewUsers, forKey: .isUnlimitedStorageEnabledForNewUsers)
        try container.encodeIfPresent(newUserDefaultStorageLimit, forKey: .newUserDefaultStorageLimit)
        try container.encodeIfPresent(newUserDefaultTimezone, forKey: .newUserDefaultTimezone)
        try container.encodeIfPresent(newUserDefaultLanguage, forKey: .newUserDefaultLanguage)
        try container.encodeIfPresent(isEnterpriseSsoRequired, forKey: .isEnterpriseSsoRequired)
        try container.encodeIfPresent(isEnterpriseSsoInTesting, forKey: .isEnterpriseSsoInTesting)
        try container.encodeIfPresent(isSsoAutoAddGroupsEnabled, forKey: .isSsoAutoAddGroupsEnabled)
        try container.encodeIfPresent(isSsoAutoAddUserToGroupsEnabled, forKey: .isSsoAutoAddUserToGroupsEnabled)
        try container.encodeIfPresent(isSsoAutoRemoveUserFromGroupsEnabled, forKey: .isSsoAutoRemoveUserFromGroupsEnabled)
        try container.encodeIfPresent(userTrackingCodes, forKey: .userTrackingCodes)
        try container.encodeIfPresent(numberOfUserTrackingCodesRemaining, forKey: .numberOfUserTrackingCodesRemaining)
        try container.encodeIfPresent(isInstantLoginRestricted, forKey: .isInstantLoginRestricted)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
