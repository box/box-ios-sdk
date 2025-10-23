import Foundation

/// The enterprise configuration for the content and sharing category.
public class EnterpriseConfigurationContentAndSharingV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case enterpriseFeatureSettings = "enterprise_feature_settings"
        case sharingItemType = "sharing_item_type"
        case sharedLinkCompanyDefinition = "shared_link_company_definition"
        case sharedLinkAccess = "shared_link_access"
        case sharedLinkDefaultAccess = "shared_link_default_access"
        case sharedLinkDefaultPermissionsSelected = "shared_link_default_permissions_selected"
        case isOpenCustomUrlsDisabled = "is_open_custom_urls_disabled"
        case isCustomDomainHiddenInSharedLink = "is_custom_domain_hidden_in_shared_link"
        case collaborationPermissions = "collaboration_permissions"
        case defaultCollaborationRole = "default_collaboration_role"
        case isInvitePrivilegeRestricted = "is_invite_privilege_restricted"
        case collaborationRestrictions = "collaboration_restrictions"
        case isCollaboratorInviteLinksDisabled = "is_collaborator_invite_links_disabled"
        case isInviteGroupCollaboratorDisabled = "is_invite_group_collaborator_disabled"
        case isOwnershipTransferRestricted = "is_ownership_transfer_restricted"
        case externalCollaborationStatus = "external_collaboration_status"
        case externalCollaborationAllowlistUsers = "external_collaboration_allowlist_users"
        case isWatermarkingEnterpriseFeatureEnabled = "is_watermarking_enterprise_feature_enabled"
        case isRootContentCreationRestricted = "is_root_content_creation_restricted"
        case isTagCreationRestricted = "is_tag_creation_restricted"
        case tagCreationRestriction = "tag_creation_restriction"
        case isEmailUploadsEnabled = "is_email_uploads_enabled"
        case isCustomSettingsEnabled = "is_custom_settings_enabled"
        case isFormsLoginRequired = "is_forms_login_required"
        case isFormsBrandingDefaultEnabled = "is_forms_branding_default_enabled"
        case isCcFreeTrialActive = "is_cc_free_trial_active"
        case isFileRequestEditorsAllowed = "is_file_request_editors_allowed"
        case isFileRequestBrandingDefaultEnabled = "is_file_request_branding_default_enabled"
        case isFileRequestLoginRequired = "is_file_request_login_required"
        case isSharedLinksExpirationEnabled = "is_shared_links_expiration_enabled"
        case sharedLinksExpirationDays = "shared_links_expiration_days"
        case isPublicSharedLinksExpirationEnabled = "is_public_shared_links_expiration_enabled"
        case publicSharedLinksExpirationDays = "public_shared_links_expiration_days"
        case sharedExpirationTarget = "shared_expiration_target"
        case isSharedLinksExpirationNotificationEnabled = "is_shared_links_expiration_notification_enabled"
        case sharedLinksExpirationNotificationDays = "shared_links_expiration_notification_days"
        case isSharedLinksExpirationNotificationPrevented = "is_shared_links_expiration_notification_prevented"
        case isAutoDeleteEnabled = "is_auto_delete_enabled"
        case autoDeleteDays = "auto_delete_days"
        case isAutoDeleteExpirationModificationPrevented = "is_auto_delete_expiration_modification_prevented"
        case autoDeleteTarget = "auto_delete_target"
        case isCollaborationExpirationEnabled = "is_collaboration_expiration_enabled"
        case collaborationExpirationDays = "collaboration_expiration_days"
        case isCollaborationExpirationModificationPrevented = "is_collaboration_expiration_modification_prevented"
        case isCollaborationExpirationNotificationEnabled = "is_collaboration_expiration_notification_enabled"
        case collaborationExpirationTarget = "collaboration_expiration_target"
        case trashAutoClearTime = "trash_auto_clear_time"
        case permanentDeletionAccess = "permanent_deletion_access"
        case permanentDeletionAllowlistUsers = "permanent_deletion_allowlist_users"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    public let enterpriseFeatureSettings: [EnterpriseFeatureSettingsItemV2025R0]?

    public let sharingItemType: EnterpriseConfigurationItemStringV2025R0?

    public let sharedLinkCompanyDefinition: EnterpriseConfigurationItemStringV2025R0?

    public let sharedLinkAccess: EnterpriseConfigurationItemStringV2025R0?

    public let sharedLinkDefaultAccess: EnterpriseConfigurationItemStringV2025R0?

    public let sharedLinkDefaultPermissionsSelected: EnterpriseConfigurationContentAndSharingV2025R0SharedLinkDefaultPermissionsSelectedField?

    public let isOpenCustomUrlsDisabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isCustomDomainHiddenInSharedLink: EnterpriseConfigurationItemBooleanV2025R0?

    public let collaborationPermissions: EnterpriseConfigurationContentAndSharingV2025R0CollaborationPermissionsField?

    public let defaultCollaborationRole: EnterpriseConfigurationItemStringV2025R0?

    public let isInvitePrivilegeRestricted: EnterpriseConfigurationItemBooleanV2025R0?

    public let collaborationRestrictions: EnterpriseConfigurationContentAndSharingV2025R0CollaborationRestrictionsField?

    public let isCollaboratorInviteLinksDisabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isInviteGroupCollaboratorDisabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isOwnershipTransferRestricted: EnterpriseConfigurationItemBooleanV2025R0?

    public let externalCollaborationStatus: EnterpriseConfigurationContentAndSharingV2025R0ExternalCollaborationStatusField?

    public let externalCollaborationAllowlistUsers: EnterpriseConfigurationContentAndSharingV2025R0ExternalCollaborationAllowlistUsersField?

    public let isWatermarkingEnterpriseFeatureEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isRootContentCreationRestricted: EnterpriseConfigurationItemBooleanV2025R0?

    public let isTagCreationRestricted: EnterpriseConfigurationItemBooleanV2025R0?

    public let tagCreationRestriction: EnterpriseConfigurationItemStringV2025R0?

    public let isEmailUploadsEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isCustomSettingsEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isFormsLoginRequired: EnterpriseConfigurationItemBooleanV2025R0?

    public let isFormsBrandingDefaultEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isCcFreeTrialActive: EnterpriseConfigurationItemBooleanV2025R0?

    public let isFileRequestEditorsAllowed: EnterpriseConfigurationItemBooleanV2025R0?

    public let isFileRequestBrandingDefaultEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isFileRequestLoginRequired: EnterpriseConfigurationItemBooleanV2025R0?

    public let isSharedLinksExpirationEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let sharedLinksExpirationDays: EnterpriseConfigurationItemIntegerV2025R0?

    public let isPublicSharedLinksExpirationEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let publicSharedLinksExpirationDays: EnterpriseConfigurationItemIntegerV2025R0?

    public let sharedExpirationTarget: EnterpriseConfigurationItemStringV2025R0?

    public let isSharedLinksExpirationNotificationEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let sharedLinksExpirationNotificationDays: EnterpriseConfigurationItemIntegerV2025R0?

    public let isSharedLinksExpirationNotificationPrevented: EnterpriseConfigurationItemBooleanV2025R0?

    public let isAutoDeleteEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let autoDeleteDays: EnterpriseConfigurationItemIntegerV2025R0?

    public let isAutoDeleteExpirationModificationPrevented: EnterpriseConfigurationItemBooleanV2025R0?

    public let autoDeleteTarget: EnterpriseConfigurationItemStringV2025R0?

    public let isCollaborationExpirationEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let collaborationExpirationDays: EnterpriseConfigurationItemIntegerV2025R0?

    public let isCollaborationExpirationModificationPrevented: EnterpriseConfigurationItemBooleanV2025R0?

    public let isCollaborationExpirationNotificationEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let collaborationExpirationTarget: EnterpriseConfigurationItemStringV2025R0?

    public let trashAutoClearTime: EnterpriseConfigurationItemIntegerV2025R0?

    public let permanentDeletionAccess: EnterpriseConfigurationItemStringV2025R0?

    public let permanentDeletionAllowlistUsers: EnterpriseConfigurationContentAndSharingV2025R0PermanentDeletionAllowlistUsersField?

    public init(enterpriseFeatureSettings: [EnterpriseFeatureSettingsItemV2025R0]? = nil, sharingItemType: EnterpriseConfigurationItemStringV2025R0? = nil, sharedLinkCompanyDefinition: EnterpriseConfigurationItemStringV2025R0? = nil, sharedLinkAccess: EnterpriseConfigurationItemStringV2025R0? = nil, sharedLinkDefaultAccess: EnterpriseConfigurationItemStringV2025R0? = nil, sharedLinkDefaultPermissionsSelected: EnterpriseConfigurationContentAndSharingV2025R0SharedLinkDefaultPermissionsSelectedField? = nil, isOpenCustomUrlsDisabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isCustomDomainHiddenInSharedLink: EnterpriseConfigurationItemBooleanV2025R0? = nil, collaborationPermissions: EnterpriseConfigurationContentAndSharingV2025R0CollaborationPermissionsField? = nil, defaultCollaborationRole: EnterpriseConfigurationItemStringV2025R0? = nil, isInvitePrivilegeRestricted: EnterpriseConfigurationItemBooleanV2025R0? = nil, collaborationRestrictions: EnterpriseConfigurationContentAndSharingV2025R0CollaborationRestrictionsField? = nil, isCollaboratorInviteLinksDisabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isInviteGroupCollaboratorDisabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isOwnershipTransferRestricted: EnterpriseConfigurationItemBooleanV2025R0? = nil, externalCollaborationStatus: EnterpriseConfigurationContentAndSharingV2025R0ExternalCollaborationStatusField? = nil, externalCollaborationAllowlistUsers: EnterpriseConfigurationContentAndSharingV2025R0ExternalCollaborationAllowlistUsersField? = nil, isWatermarkingEnterpriseFeatureEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isRootContentCreationRestricted: EnterpriseConfigurationItemBooleanV2025R0? = nil, isTagCreationRestricted: EnterpriseConfigurationItemBooleanV2025R0? = nil, tagCreationRestriction: EnterpriseConfigurationItemStringV2025R0? = nil, isEmailUploadsEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isCustomSettingsEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isFormsLoginRequired: EnterpriseConfigurationItemBooleanV2025R0? = nil, isFormsBrandingDefaultEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isCcFreeTrialActive: EnterpriseConfigurationItemBooleanV2025R0? = nil, isFileRequestEditorsAllowed: EnterpriseConfigurationItemBooleanV2025R0? = nil, isFileRequestBrandingDefaultEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isFileRequestLoginRequired: EnterpriseConfigurationItemBooleanV2025R0? = nil, isSharedLinksExpirationEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, sharedLinksExpirationDays: EnterpriseConfigurationItemIntegerV2025R0? = nil, isPublicSharedLinksExpirationEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, publicSharedLinksExpirationDays: EnterpriseConfigurationItemIntegerV2025R0? = nil, sharedExpirationTarget: EnterpriseConfigurationItemStringV2025R0? = nil, isSharedLinksExpirationNotificationEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, sharedLinksExpirationNotificationDays: EnterpriseConfigurationItemIntegerV2025R0? = nil, isSharedLinksExpirationNotificationPrevented: EnterpriseConfigurationItemBooleanV2025R0? = nil, isAutoDeleteEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, autoDeleteDays: EnterpriseConfigurationItemIntegerV2025R0? = nil, isAutoDeleteExpirationModificationPrevented: EnterpriseConfigurationItemBooleanV2025R0? = nil, autoDeleteTarget: EnterpriseConfigurationItemStringV2025R0? = nil, isCollaborationExpirationEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, collaborationExpirationDays: EnterpriseConfigurationItemIntegerV2025R0? = nil, isCollaborationExpirationModificationPrevented: EnterpriseConfigurationItemBooleanV2025R0? = nil, isCollaborationExpirationNotificationEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, collaborationExpirationTarget: EnterpriseConfigurationItemStringV2025R0? = nil, trashAutoClearTime: EnterpriseConfigurationItemIntegerV2025R0? = nil, permanentDeletionAccess: EnterpriseConfigurationItemStringV2025R0? = nil, permanentDeletionAllowlistUsers: EnterpriseConfigurationContentAndSharingV2025R0PermanentDeletionAllowlistUsersField? = nil) {
        self.enterpriseFeatureSettings = enterpriseFeatureSettings
        self.sharingItemType = sharingItemType
        self.sharedLinkCompanyDefinition = sharedLinkCompanyDefinition
        self.sharedLinkAccess = sharedLinkAccess
        self.sharedLinkDefaultAccess = sharedLinkDefaultAccess
        self.sharedLinkDefaultPermissionsSelected = sharedLinkDefaultPermissionsSelected
        self.isOpenCustomUrlsDisabled = isOpenCustomUrlsDisabled
        self.isCustomDomainHiddenInSharedLink = isCustomDomainHiddenInSharedLink
        self.collaborationPermissions = collaborationPermissions
        self.defaultCollaborationRole = defaultCollaborationRole
        self.isInvitePrivilegeRestricted = isInvitePrivilegeRestricted
        self.collaborationRestrictions = collaborationRestrictions
        self.isCollaboratorInviteLinksDisabled = isCollaboratorInviteLinksDisabled
        self.isInviteGroupCollaboratorDisabled = isInviteGroupCollaboratorDisabled
        self.isOwnershipTransferRestricted = isOwnershipTransferRestricted
        self.externalCollaborationStatus = externalCollaborationStatus
        self.externalCollaborationAllowlistUsers = externalCollaborationAllowlistUsers
        self.isWatermarkingEnterpriseFeatureEnabled = isWatermarkingEnterpriseFeatureEnabled
        self.isRootContentCreationRestricted = isRootContentCreationRestricted
        self.isTagCreationRestricted = isTagCreationRestricted
        self.tagCreationRestriction = tagCreationRestriction
        self.isEmailUploadsEnabled = isEmailUploadsEnabled
        self.isCustomSettingsEnabled = isCustomSettingsEnabled
        self.isFormsLoginRequired = isFormsLoginRequired
        self.isFormsBrandingDefaultEnabled = isFormsBrandingDefaultEnabled
        self.isCcFreeTrialActive = isCcFreeTrialActive
        self.isFileRequestEditorsAllowed = isFileRequestEditorsAllowed
        self.isFileRequestBrandingDefaultEnabled = isFileRequestBrandingDefaultEnabled
        self.isFileRequestLoginRequired = isFileRequestLoginRequired
        self.isSharedLinksExpirationEnabled = isSharedLinksExpirationEnabled
        self.sharedLinksExpirationDays = sharedLinksExpirationDays
        self.isPublicSharedLinksExpirationEnabled = isPublicSharedLinksExpirationEnabled
        self.publicSharedLinksExpirationDays = publicSharedLinksExpirationDays
        self.sharedExpirationTarget = sharedExpirationTarget
        self.isSharedLinksExpirationNotificationEnabled = isSharedLinksExpirationNotificationEnabled
        self.sharedLinksExpirationNotificationDays = sharedLinksExpirationNotificationDays
        self.isSharedLinksExpirationNotificationPrevented = isSharedLinksExpirationNotificationPrevented
        self.isAutoDeleteEnabled = isAutoDeleteEnabled
        self.autoDeleteDays = autoDeleteDays
        self.isAutoDeleteExpirationModificationPrevented = isAutoDeleteExpirationModificationPrevented
        self.autoDeleteTarget = autoDeleteTarget
        self.isCollaborationExpirationEnabled = isCollaborationExpirationEnabled
        self.collaborationExpirationDays = collaborationExpirationDays
        self.isCollaborationExpirationModificationPrevented = isCollaborationExpirationModificationPrevented
        self.isCollaborationExpirationNotificationEnabled = isCollaborationExpirationNotificationEnabled
        self.collaborationExpirationTarget = collaborationExpirationTarget
        self.trashAutoClearTime = trashAutoClearTime
        self.permanentDeletionAccess = permanentDeletionAccess
        self.permanentDeletionAllowlistUsers = permanentDeletionAllowlistUsers
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        enterpriseFeatureSettings = try container.decodeIfPresent([EnterpriseFeatureSettingsItemV2025R0].self, forKey: .enterpriseFeatureSettings)
        sharingItemType = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .sharingItemType)
        sharedLinkCompanyDefinition = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .sharedLinkCompanyDefinition)
        sharedLinkAccess = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .sharedLinkAccess)
        sharedLinkDefaultAccess = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .sharedLinkDefaultAccess)
        sharedLinkDefaultPermissionsSelected = try container.decodeIfPresent(EnterpriseConfigurationContentAndSharingV2025R0SharedLinkDefaultPermissionsSelectedField.self, forKey: .sharedLinkDefaultPermissionsSelected)
        isOpenCustomUrlsDisabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isOpenCustomUrlsDisabled)
        isCustomDomainHiddenInSharedLink = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isCustomDomainHiddenInSharedLink)
        collaborationPermissions = try container.decodeIfPresent(EnterpriseConfigurationContentAndSharingV2025R0CollaborationPermissionsField.self, forKey: .collaborationPermissions)
        defaultCollaborationRole = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .defaultCollaborationRole)
        isInvitePrivilegeRestricted = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isInvitePrivilegeRestricted)
        collaborationRestrictions = try container.decodeIfPresent(EnterpriseConfigurationContentAndSharingV2025R0CollaborationRestrictionsField.self, forKey: .collaborationRestrictions)
        isCollaboratorInviteLinksDisabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isCollaboratorInviteLinksDisabled)
        isInviteGroupCollaboratorDisabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isInviteGroupCollaboratorDisabled)
        isOwnershipTransferRestricted = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isOwnershipTransferRestricted)
        externalCollaborationStatus = try container.decodeIfPresent(EnterpriseConfigurationContentAndSharingV2025R0ExternalCollaborationStatusField.self, forKey: .externalCollaborationStatus)
        externalCollaborationAllowlistUsers = try container.decodeIfPresent(EnterpriseConfigurationContentAndSharingV2025R0ExternalCollaborationAllowlistUsersField.self, forKey: .externalCollaborationAllowlistUsers)
        isWatermarkingEnterpriseFeatureEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isWatermarkingEnterpriseFeatureEnabled)
        isRootContentCreationRestricted = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isRootContentCreationRestricted)
        isTagCreationRestricted = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isTagCreationRestricted)
        tagCreationRestriction = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .tagCreationRestriction)
        isEmailUploadsEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isEmailUploadsEnabled)
        isCustomSettingsEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isCustomSettingsEnabled)
        isFormsLoginRequired = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isFormsLoginRequired)
        isFormsBrandingDefaultEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isFormsBrandingDefaultEnabled)
        isCcFreeTrialActive = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isCcFreeTrialActive)
        isFileRequestEditorsAllowed = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isFileRequestEditorsAllowed)
        isFileRequestBrandingDefaultEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isFileRequestBrandingDefaultEnabled)
        isFileRequestLoginRequired = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isFileRequestLoginRequired)
        isSharedLinksExpirationEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isSharedLinksExpirationEnabled)
        sharedLinksExpirationDays = try container.decodeIfPresent(EnterpriseConfigurationItemIntegerV2025R0.self, forKey: .sharedLinksExpirationDays)
        isPublicSharedLinksExpirationEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isPublicSharedLinksExpirationEnabled)
        publicSharedLinksExpirationDays = try container.decodeIfPresent(EnterpriseConfigurationItemIntegerV2025R0.self, forKey: .publicSharedLinksExpirationDays)
        sharedExpirationTarget = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .sharedExpirationTarget)
        isSharedLinksExpirationNotificationEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isSharedLinksExpirationNotificationEnabled)
        sharedLinksExpirationNotificationDays = try container.decodeIfPresent(EnterpriseConfigurationItemIntegerV2025R0.self, forKey: .sharedLinksExpirationNotificationDays)
        isSharedLinksExpirationNotificationPrevented = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isSharedLinksExpirationNotificationPrevented)
        isAutoDeleteEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isAutoDeleteEnabled)
        autoDeleteDays = try container.decodeIfPresent(EnterpriseConfigurationItemIntegerV2025R0.self, forKey: .autoDeleteDays)
        isAutoDeleteExpirationModificationPrevented = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isAutoDeleteExpirationModificationPrevented)
        autoDeleteTarget = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .autoDeleteTarget)
        isCollaborationExpirationEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isCollaborationExpirationEnabled)
        collaborationExpirationDays = try container.decodeIfPresent(EnterpriseConfigurationItemIntegerV2025R0.self, forKey: .collaborationExpirationDays)
        isCollaborationExpirationModificationPrevented = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isCollaborationExpirationModificationPrevented)
        isCollaborationExpirationNotificationEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isCollaborationExpirationNotificationEnabled)
        collaborationExpirationTarget = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .collaborationExpirationTarget)
        trashAutoClearTime = try container.decodeIfPresent(EnterpriseConfigurationItemIntegerV2025R0.self, forKey: .trashAutoClearTime)
        permanentDeletionAccess = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .permanentDeletionAccess)
        permanentDeletionAllowlistUsers = try container.decodeIfPresent(EnterpriseConfigurationContentAndSharingV2025R0PermanentDeletionAllowlistUsersField.self, forKey: .permanentDeletionAllowlistUsers)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(enterpriseFeatureSettings, forKey: .enterpriseFeatureSettings)
        try container.encodeIfPresent(sharingItemType, forKey: .sharingItemType)
        try container.encodeIfPresent(sharedLinkCompanyDefinition, forKey: .sharedLinkCompanyDefinition)
        try container.encodeIfPresent(sharedLinkAccess, forKey: .sharedLinkAccess)
        try container.encodeIfPresent(sharedLinkDefaultAccess, forKey: .sharedLinkDefaultAccess)
        try container.encodeIfPresent(sharedLinkDefaultPermissionsSelected, forKey: .sharedLinkDefaultPermissionsSelected)
        try container.encodeIfPresent(isOpenCustomUrlsDisabled, forKey: .isOpenCustomUrlsDisabled)
        try container.encodeIfPresent(isCustomDomainHiddenInSharedLink, forKey: .isCustomDomainHiddenInSharedLink)
        try container.encodeIfPresent(collaborationPermissions, forKey: .collaborationPermissions)
        try container.encodeIfPresent(defaultCollaborationRole, forKey: .defaultCollaborationRole)
        try container.encodeIfPresent(isInvitePrivilegeRestricted, forKey: .isInvitePrivilegeRestricted)
        try container.encodeIfPresent(collaborationRestrictions, forKey: .collaborationRestrictions)
        try container.encodeIfPresent(isCollaboratorInviteLinksDisabled, forKey: .isCollaboratorInviteLinksDisabled)
        try container.encodeIfPresent(isInviteGroupCollaboratorDisabled, forKey: .isInviteGroupCollaboratorDisabled)
        try container.encodeIfPresent(isOwnershipTransferRestricted, forKey: .isOwnershipTransferRestricted)
        try container.encodeIfPresent(externalCollaborationStatus, forKey: .externalCollaborationStatus)
        try container.encodeIfPresent(externalCollaborationAllowlistUsers, forKey: .externalCollaborationAllowlistUsers)
        try container.encodeIfPresent(isWatermarkingEnterpriseFeatureEnabled, forKey: .isWatermarkingEnterpriseFeatureEnabled)
        try container.encodeIfPresent(isRootContentCreationRestricted, forKey: .isRootContentCreationRestricted)
        try container.encodeIfPresent(isTagCreationRestricted, forKey: .isTagCreationRestricted)
        try container.encodeIfPresent(tagCreationRestriction, forKey: .tagCreationRestriction)
        try container.encodeIfPresent(isEmailUploadsEnabled, forKey: .isEmailUploadsEnabled)
        try container.encodeIfPresent(isCustomSettingsEnabled, forKey: .isCustomSettingsEnabled)
        try container.encodeIfPresent(isFormsLoginRequired, forKey: .isFormsLoginRequired)
        try container.encodeIfPresent(isFormsBrandingDefaultEnabled, forKey: .isFormsBrandingDefaultEnabled)
        try container.encodeIfPresent(isCcFreeTrialActive, forKey: .isCcFreeTrialActive)
        try container.encodeIfPresent(isFileRequestEditorsAllowed, forKey: .isFileRequestEditorsAllowed)
        try container.encodeIfPresent(isFileRequestBrandingDefaultEnabled, forKey: .isFileRequestBrandingDefaultEnabled)
        try container.encodeIfPresent(isFileRequestLoginRequired, forKey: .isFileRequestLoginRequired)
        try container.encodeIfPresent(isSharedLinksExpirationEnabled, forKey: .isSharedLinksExpirationEnabled)
        try container.encodeIfPresent(sharedLinksExpirationDays, forKey: .sharedLinksExpirationDays)
        try container.encodeIfPresent(isPublicSharedLinksExpirationEnabled, forKey: .isPublicSharedLinksExpirationEnabled)
        try container.encodeIfPresent(publicSharedLinksExpirationDays, forKey: .publicSharedLinksExpirationDays)
        try container.encodeIfPresent(sharedExpirationTarget, forKey: .sharedExpirationTarget)
        try container.encodeIfPresent(isSharedLinksExpirationNotificationEnabled, forKey: .isSharedLinksExpirationNotificationEnabled)
        try container.encodeIfPresent(sharedLinksExpirationNotificationDays, forKey: .sharedLinksExpirationNotificationDays)
        try container.encodeIfPresent(isSharedLinksExpirationNotificationPrevented, forKey: .isSharedLinksExpirationNotificationPrevented)
        try container.encodeIfPresent(isAutoDeleteEnabled, forKey: .isAutoDeleteEnabled)
        try container.encodeIfPresent(autoDeleteDays, forKey: .autoDeleteDays)
        try container.encodeIfPresent(isAutoDeleteExpirationModificationPrevented, forKey: .isAutoDeleteExpirationModificationPrevented)
        try container.encodeIfPresent(autoDeleteTarget, forKey: .autoDeleteTarget)
        try container.encodeIfPresent(isCollaborationExpirationEnabled, forKey: .isCollaborationExpirationEnabled)
        try container.encodeIfPresent(collaborationExpirationDays, forKey: .collaborationExpirationDays)
        try container.encodeIfPresent(isCollaborationExpirationModificationPrevented, forKey: .isCollaborationExpirationModificationPrevented)
        try container.encodeIfPresent(isCollaborationExpirationNotificationEnabled, forKey: .isCollaborationExpirationNotificationEnabled)
        try container.encodeIfPresent(collaborationExpirationTarget, forKey: .collaborationExpirationTarget)
        try container.encodeIfPresent(trashAutoClearTime, forKey: .trashAutoClearTime)
        try container.encodeIfPresent(permanentDeletionAccess, forKey: .permanentDeletionAccess)
        try container.encodeIfPresent(permanentDeletionAllowlistUsers, forKey: .permanentDeletionAllowlistUsers)
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
