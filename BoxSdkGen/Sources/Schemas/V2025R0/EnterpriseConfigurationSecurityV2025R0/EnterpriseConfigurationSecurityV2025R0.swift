import Foundation

/// The enterprise configuration for the security category.
public class EnterpriseConfigurationSecurityV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case isManagedUserSignupEnabled = "is_managed_user_signup_enabled"
        case isManagedUserSignupNotificationEnabled = "is_managed_user_signup_notification_enabled"
        case isManagedUserSignupCorporateEmailEnabled = "is_managed_user_signup_corporate_email_enabled"
        case isNewUserNotificationDailyDigestEnabled = "is_new_user_notification_daily_digest_enabled"
        case isManagedUserEmailChangeDisabled = "is_managed_user_email_change_disabled"
        case isMultiFactorAuthRequired = "is_multi_factor_auth_required"
        case isWeakPasswordPreventionEnabled = "is_weak_password_prevention_enabled"
        case isPasswordLeakDetectionEnabled = "is_password_leak_detection_enabled"
        case lastPasswordResetAt = "last_password_reset_at"
        case isPasswordRequestNotificationEnabled = "is_password_request_notification_enabled"
        case isPasswordChangeNotificationEnabled = "is_password_change_notification_enabled"
        case isStrongPasswordForExtCollabEnabled = "is_strong_password_for_ext_collab_enabled"
        case isManagedUserMigrationDisabled = "is_managed_user_migration_disabled"
        case joinLink = "join_link"
        case joinUrl = "join_url"
        case failedLoginAttemptsToTriggerAdminNotification = "failed_login_attempts_to_trigger_admin_notification"
        case passwordMinLength = "password_min_length"
        case passwordMinUppercaseCharacters = "password_min_uppercase_characters"
        case passwordMinNumericCharacters = "password_min_numeric_characters"
        case passwordMinSpecialCharacters = "password_min_special_characters"
        case passwordResetFrequency = "password_reset_frequency"
        case previousPasswordReuseLimit = "previous_password_reuse_limit"
        case sessionDuration = "session_duration"
        case externalCollabMultiFactorAuthSettings = "external_collab_multi_factor_auth_settings"
        case keysafe
        case isCustomSessionDurationEnabled = "is_custom_session_duration_enabled"
        case customSessionDurationValue = "custom_session_duration_value"
        case customSessionDurationGroups = "custom_session_duration_groups"
        case multiFactorAuthType = "multi_factor_auth_type"
        case enforcedMfaFrequency = "enforced_mfa_frequency"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    public let isManagedUserSignupEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isManagedUserSignupNotificationEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isManagedUserSignupCorporateEmailEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isNewUserNotificationDailyDigestEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isManagedUserEmailChangeDisabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isMultiFactorAuthRequired: EnterpriseConfigurationItemBooleanV2025R0?

    public let isWeakPasswordPreventionEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isPasswordLeakDetectionEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let lastPasswordResetAt: EnterpriseConfigurationSecurityV2025R0LastPasswordResetAtField?

    public let isPasswordRequestNotificationEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isPasswordChangeNotificationEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isStrongPasswordForExtCollabEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let isManagedUserMigrationDisabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let joinLink: EnterpriseConfigurationItemStringV2025R0?

    public let joinUrl: EnterpriseConfigurationItemStringV2025R0?

    public let failedLoginAttemptsToTriggerAdminNotification: EnterpriseConfigurationItemIntegerV2025R0?

    public let passwordMinLength: EnterpriseConfigurationItemIntegerV2025R0?

    public let passwordMinUppercaseCharacters: EnterpriseConfigurationItemIntegerV2025R0?

    public let passwordMinNumericCharacters: EnterpriseConfigurationItemIntegerV2025R0?

    public let passwordMinSpecialCharacters: EnterpriseConfigurationItemIntegerV2025R0?

    public let passwordResetFrequency: EnterpriseConfigurationItemStringV2025R0?

    public let previousPasswordReuseLimit: EnterpriseConfigurationItemStringV2025R0?

    public let sessionDuration: EnterpriseConfigurationItemStringV2025R0?

    public let externalCollabMultiFactorAuthSettings: EnterpriseConfigurationSecurityV2025R0ExternalCollabMultiFactorAuthSettingsField?

    public let keysafe: EnterpriseConfigurationSecurityV2025R0KeysafeField?

    public let isCustomSessionDurationEnabled: EnterpriseConfigurationItemBooleanV2025R0?

    public let customSessionDurationValue: EnterpriseConfigurationItemStringV2025R0?

    public let customSessionDurationGroups: EnterpriseConfigurationSecurityV2025R0CustomSessionDurationGroupsField?

    public let multiFactorAuthType: EnterpriseConfigurationItemStringV2025R0?

    public let enforcedMfaFrequency: EnterpriseConfigurationSecurityV2025R0EnforcedMfaFrequencyField?

    public init(isManagedUserSignupEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isManagedUserSignupNotificationEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isManagedUserSignupCorporateEmailEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isNewUserNotificationDailyDigestEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isManagedUserEmailChangeDisabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isMultiFactorAuthRequired: EnterpriseConfigurationItemBooleanV2025R0? = nil, isWeakPasswordPreventionEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isPasswordLeakDetectionEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, lastPasswordResetAt: EnterpriseConfigurationSecurityV2025R0LastPasswordResetAtField? = nil, isPasswordRequestNotificationEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isPasswordChangeNotificationEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isStrongPasswordForExtCollabEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, isManagedUserMigrationDisabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, joinLink: EnterpriseConfigurationItemStringV2025R0? = nil, joinUrl: EnterpriseConfigurationItemStringV2025R0? = nil, failedLoginAttemptsToTriggerAdminNotification: EnterpriseConfigurationItemIntegerV2025R0? = nil, passwordMinLength: EnterpriseConfigurationItemIntegerV2025R0? = nil, passwordMinUppercaseCharacters: EnterpriseConfigurationItemIntegerV2025R0? = nil, passwordMinNumericCharacters: EnterpriseConfigurationItemIntegerV2025R0? = nil, passwordMinSpecialCharacters: EnterpriseConfigurationItemIntegerV2025R0? = nil, passwordResetFrequency: EnterpriseConfigurationItemStringV2025R0? = nil, previousPasswordReuseLimit: EnterpriseConfigurationItemStringV2025R0? = nil, sessionDuration: EnterpriseConfigurationItemStringV2025R0? = nil, externalCollabMultiFactorAuthSettings: EnterpriseConfigurationSecurityV2025R0ExternalCollabMultiFactorAuthSettingsField? = nil, keysafe: EnterpriseConfigurationSecurityV2025R0KeysafeField? = nil, isCustomSessionDurationEnabled: EnterpriseConfigurationItemBooleanV2025R0? = nil, customSessionDurationValue: EnterpriseConfigurationItemStringV2025R0? = nil, customSessionDurationGroups: EnterpriseConfigurationSecurityV2025R0CustomSessionDurationGroupsField? = nil, multiFactorAuthType: EnterpriseConfigurationItemStringV2025R0? = nil, enforcedMfaFrequency: EnterpriseConfigurationSecurityV2025R0EnforcedMfaFrequencyField? = nil) {
        self.isManagedUserSignupEnabled = isManagedUserSignupEnabled
        self.isManagedUserSignupNotificationEnabled = isManagedUserSignupNotificationEnabled
        self.isManagedUserSignupCorporateEmailEnabled = isManagedUserSignupCorporateEmailEnabled
        self.isNewUserNotificationDailyDigestEnabled = isNewUserNotificationDailyDigestEnabled
        self.isManagedUserEmailChangeDisabled = isManagedUserEmailChangeDisabled
        self.isMultiFactorAuthRequired = isMultiFactorAuthRequired
        self.isWeakPasswordPreventionEnabled = isWeakPasswordPreventionEnabled
        self.isPasswordLeakDetectionEnabled = isPasswordLeakDetectionEnabled
        self.lastPasswordResetAt = lastPasswordResetAt
        self.isPasswordRequestNotificationEnabled = isPasswordRequestNotificationEnabled
        self.isPasswordChangeNotificationEnabled = isPasswordChangeNotificationEnabled
        self.isStrongPasswordForExtCollabEnabled = isStrongPasswordForExtCollabEnabled
        self.isManagedUserMigrationDisabled = isManagedUserMigrationDisabled
        self.joinLink = joinLink
        self.joinUrl = joinUrl
        self.failedLoginAttemptsToTriggerAdminNotification = failedLoginAttemptsToTriggerAdminNotification
        self.passwordMinLength = passwordMinLength
        self.passwordMinUppercaseCharacters = passwordMinUppercaseCharacters
        self.passwordMinNumericCharacters = passwordMinNumericCharacters
        self.passwordMinSpecialCharacters = passwordMinSpecialCharacters
        self.passwordResetFrequency = passwordResetFrequency
        self.previousPasswordReuseLimit = previousPasswordReuseLimit
        self.sessionDuration = sessionDuration
        self.externalCollabMultiFactorAuthSettings = externalCollabMultiFactorAuthSettings
        self.keysafe = keysafe
        self.isCustomSessionDurationEnabled = isCustomSessionDurationEnabled
        self.customSessionDurationValue = customSessionDurationValue
        self.customSessionDurationGroups = customSessionDurationGroups
        self.multiFactorAuthType = multiFactorAuthType
        self.enforcedMfaFrequency = enforcedMfaFrequency
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isManagedUserSignupEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isManagedUserSignupEnabled)
        isManagedUserSignupNotificationEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isManagedUserSignupNotificationEnabled)
        isManagedUserSignupCorporateEmailEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isManagedUserSignupCorporateEmailEnabled)
        isNewUserNotificationDailyDigestEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isNewUserNotificationDailyDigestEnabled)
        isManagedUserEmailChangeDisabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isManagedUserEmailChangeDisabled)
        isMultiFactorAuthRequired = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isMultiFactorAuthRequired)
        isWeakPasswordPreventionEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isWeakPasswordPreventionEnabled)
        isPasswordLeakDetectionEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isPasswordLeakDetectionEnabled)
        lastPasswordResetAt = try container.decodeIfPresent(EnterpriseConfigurationSecurityV2025R0LastPasswordResetAtField.self, forKey: .lastPasswordResetAt)
        isPasswordRequestNotificationEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isPasswordRequestNotificationEnabled)
        isPasswordChangeNotificationEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isPasswordChangeNotificationEnabled)
        isStrongPasswordForExtCollabEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isStrongPasswordForExtCollabEnabled)
        isManagedUserMigrationDisabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isManagedUserMigrationDisabled)
        joinLink = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .joinLink)
        joinUrl = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .joinUrl)
        failedLoginAttemptsToTriggerAdminNotification = try container.decodeIfPresent(EnterpriseConfigurationItemIntegerV2025R0.self, forKey: .failedLoginAttemptsToTriggerAdminNotification)
        passwordMinLength = try container.decodeIfPresent(EnterpriseConfigurationItemIntegerV2025R0.self, forKey: .passwordMinLength)
        passwordMinUppercaseCharacters = try container.decodeIfPresent(EnterpriseConfigurationItemIntegerV2025R0.self, forKey: .passwordMinUppercaseCharacters)
        passwordMinNumericCharacters = try container.decodeIfPresent(EnterpriseConfigurationItemIntegerV2025R0.self, forKey: .passwordMinNumericCharacters)
        passwordMinSpecialCharacters = try container.decodeIfPresent(EnterpriseConfigurationItemIntegerV2025R0.self, forKey: .passwordMinSpecialCharacters)
        passwordResetFrequency = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .passwordResetFrequency)
        previousPasswordReuseLimit = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .previousPasswordReuseLimit)
        sessionDuration = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .sessionDuration)
        externalCollabMultiFactorAuthSettings = try container.decodeIfPresent(EnterpriseConfigurationSecurityV2025R0ExternalCollabMultiFactorAuthSettingsField.self, forKey: .externalCollabMultiFactorAuthSettings)
        keysafe = try container.decodeIfPresent(EnterpriseConfigurationSecurityV2025R0KeysafeField.self, forKey: .keysafe)
        isCustomSessionDurationEnabled = try container.decodeIfPresent(EnterpriseConfigurationItemBooleanV2025R0.self, forKey: .isCustomSessionDurationEnabled)
        customSessionDurationValue = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .customSessionDurationValue)
        customSessionDurationGroups = try container.decodeIfPresent(EnterpriseConfigurationSecurityV2025R0CustomSessionDurationGroupsField.self, forKey: .customSessionDurationGroups)
        multiFactorAuthType = try container.decodeIfPresent(EnterpriseConfigurationItemStringV2025R0.self, forKey: .multiFactorAuthType)
        enforcedMfaFrequency = try container.decodeIfPresent(EnterpriseConfigurationSecurityV2025R0EnforcedMfaFrequencyField.self, forKey: .enforcedMfaFrequency)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isManagedUserSignupEnabled, forKey: .isManagedUserSignupEnabled)
        try container.encodeIfPresent(isManagedUserSignupNotificationEnabled, forKey: .isManagedUserSignupNotificationEnabled)
        try container.encodeIfPresent(isManagedUserSignupCorporateEmailEnabled, forKey: .isManagedUserSignupCorporateEmailEnabled)
        try container.encodeIfPresent(isNewUserNotificationDailyDigestEnabled, forKey: .isNewUserNotificationDailyDigestEnabled)
        try container.encodeIfPresent(isManagedUserEmailChangeDisabled, forKey: .isManagedUserEmailChangeDisabled)
        try container.encodeIfPresent(isMultiFactorAuthRequired, forKey: .isMultiFactorAuthRequired)
        try container.encodeIfPresent(isWeakPasswordPreventionEnabled, forKey: .isWeakPasswordPreventionEnabled)
        try container.encodeIfPresent(isPasswordLeakDetectionEnabled, forKey: .isPasswordLeakDetectionEnabled)
        try container.encodeIfPresent(lastPasswordResetAt, forKey: .lastPasswordResetAt)
        try container.encodeIfPresent(isPasswordRequestNotificationEnabled, forKey: .isPasswordRequestNotificationEnabled)
        try container.encodeIfPresent(isPasswordChangeNotificationEnabled, forKey: .isPasswordChangeNotificationEnabled)
        try container.encodeIfPresent(isStrongPasswordForExtCollabEnabled, forKey: .isStrongPasswordForExtCollabEnabled)
        try container.encodeIfPresent(isManagedUserMigrationDisabled, forKey: .isManagedUserMigrationDisabled)
        try container.encodeIfPresent(joinLink, forKey: .joinLink)
        try container.encodeIfPresent(joinUrl, forKey: .joinUrl)
        try container.encodeIfPresent(failedLoginAttemptsToTriggerAdminNotification, forKey: .failedLoginAttemptsToTriggerAdminNotification)
        try container.encodeIfPresent(passwordMinLength, forKey: .passwordMinLength)
        try container.encodeIfPresent(passwordMinUppercaseCharacters, forKey: .passwordMinUppercaseCharacters)
        try container.encodeIfPresent(passwordMinNumericCharacters, forKey: .passwordMinNumericCharacters)
        try container.encodeIfPresent(passwordMinSpecialCharacters, forKey: .passwordMinSpecialCharacters)
        try container.encodeIfPresent(passwordResetFrequency, forKey: .passwordResetFrequency)
        try container.encodeIfPresent(previousPasswordReuseLimit, forKey: .previousPasswordReuseLimit)
        try container.encodeIfPresent(sessionDuration, forKey: .sessionDuration)
        try container.encodeIfPresent(externalCollabMultiFactorAuthSettings, forKey: .externalCollabMultiFactorAuthSettings)
        try container.encodeIfPresent(keysafe, forKey: .keysafe)
        try container.encodeIfPresent(isCustomSessionDurationEnabled, forKey: .isCustomSessionDurationEnabled)
        try container.encodeIfPresent(customSessionDurationValue, forKey: .customSessionDurationValue)
        try container.encodeIfPresent(customSessionDurationGroups, forKey: .customSessionDurationGroups)
        try container.encodeIfPresent(multiFactorAuthType, forKey: .multiFactorAuthType)
        try container.encodeIfPresent(enforcedMfaFrequency, forKey: .enforcedMfaFrequency)
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
