import Foundation

/// A Box Sign template object
public class SignTemplate: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case name
        case emailSubject = "email_subject"
        case emailMessage = "email_message"
        case daysValid = "days_valid"
        case parentFolder = "parent_folder"
        case sourceFiles = "source_files"
        case areFieldsLocked = "are_fields_locked"
        case areOptionsLocked = "are_options_locked"
        case areRecipientsLocked = "are_recipients_locked"
        case areEmailSettingsLocked = "are_email_settings_locked"
        case areFilesLocked = "are_files_locked"
        case signers
        case additionalInfo = "additional_info"
        case readySignLink = "ready_sign_link"
        case customBranding = "custom_branding"
    }

    /// object type
    public let type: SignTemplateTypeField?

    /// Template identifier.
    public let id: String?

    /// The name of the template.
    @CodableTriState public private(set) var name: String?

    /// Subject of signature request email. This is cleaned by sign request. If this field is not passed, a default subject will be used.
    @CodableTriState public private(set) var emailSubject: String?

    /// Message to include in signature request email. The field is cleaned through sanitization of specific characters. However, some html tags are allowed. Links included in the message are also converted to hyperlinks in the email. The message may contain the following html tags including `a`, `abbr`, `acronym`, `b`, `blockquote`, `code`, `em`, `i`, `ul`, `li`, `ol`, and `strong`. Be aware that when the text to html ratio is too high, the email may end up in spam filters. Custom styles on these tags are not allowed. If this field is not passed, a default message will be used.
    @CodableTriState public private(set) var emailMessage: String?

    /// Set the number of days after which the created signature request will automatically expire if not completed. By default, we do not apply any expiration date on signature requests, and the signature request does not expire.
    @CodableTriState public private(set) var daysValid: Int64?

    public let parentFolder: FolderMini?

    /// List of files to create a signing document from. Only the ID and type fields are required for each file.
    public let sourceFiles: [FileMini]?

    /// Indicates if the template input fields are editable or not.
    public let areFieldsLocked: Bool?

    /// Indicates if the template document options are editable or not, for example renaming the document.
    public let areOptionsLocked: Bool?

    /// Indicates if the template signers are editable or not.
    public let areRecipientsLocked: Bool?

    /// Indicates if the template email settings are editable or not.
    public let areEmailSettingsLocked: Bool?

    /// Indicates if the template files are editable or not. This includes deleting or renaming template files.
    public let areFilesLocked: Bool?

    /// Array of signers for the template.
    /// 
    /// **Note**: It may happen that some signers specified in the template belong to conflicting [segments](r://shield-information-barrier-segment-member) (user groups).
    /// This means that due to the security policies, users are assigned to segments to prevent exchanges or communication that could lead to ethical conflicts.
    /// In such a case, an attempt to send a sign request based on a template that lists signers in conflicting segments will result in an error.
    /// 
    /// Read more about [segments and ethical walls](https://support.box.com/hc/en-us/articles/9920431507603-Understanding-Information-Barriers#h_01GFVJEHQA06N7XEZ4GCZ9GFAQ).
    public let signers: [TemplateSigner]?

    /// Additional information on which fields are required and which fields are not editable.
    public let additionalInfo: SignTemplateAdditionalInfoField?

    /// Box's ready-sign link feature enables you to create a link to a signature request that you've created from a template. Use this link when you want to post a signature request on a public form — such as an email, social media post, or web page — without knowing who the signers will be. Note: The ready-sign link feature is limited to Enterprise Plus customers and not available to Box Verified Enterprises.
    @CodableTriState public private(set) var readySignLink: SignTemplateReadySignLinkField?

    /// Custom branding applied to notifications
    /// and signature requests.
    @CodableTriState public private(set) var customBranding: SignTemplateCustomBrandingField?

    /// Initializer for a SignTemplate.
    ///
    /// - Parameters:
    ///   - type: object type
    ///   - id: Template identifier.
    ///   - name: The name of the template.
    ///   - emailSubject: Subject of signature request email. This is cleaned by sign request. If this field is not passed, a default subject will be used.
    ///   - emailMessage: Message to include in signature request email. The field is cleaned through sanitization of specific characters. However, some html tags are allowed. Links included in the message are also converted to hyperlinks in the email. The message may contain the following html tags including `a`, `abbr`, `acronym`, `b`, `blockquote`, `code`, `em`, `i`, `ul`, `li`, `ol`, and `strong`. Be aware that when the text to html ratio is too high, the email may end up in spam filters. Custom styles on these tags are not allowed. If this field is not passed, a default message will be used.
    ///   - daysValid: Set the number of days after which the created signature request will automatically expire if not completed. By default, we do not apply any expiration date on signature requests, and the signature request does not expire.
    ///   - parentFolder: 
    ///   - sourceFiles: List of files to create a signing document from. Only the ID and type fields are required for each file.
    ///   - areFieldsLocked: Indicates if the template input fields are editable or not.
    ///   - areOptionsLocked: Indicates if the template document options are editable or not, for example renaming the document.
    ///   - areRecipientsLocked: Indicates if the template signers are editable or not.
    ///   - areEmailSettingsLocked: Indicates if the template email settings are editable or not.
    ///   - areFilesLocked: Indicates if the template files are editable or not. This includes deleting or renaming template files.
    ///   - signers: Array of signers for the template.
    ///     
    ///     **Note**: It may happen that some signers specified in the template belong to conflicting [segments](r://shield-information-barrier-segment-member) (user groups).
    ///     This means that due to the security policies, users are assigned to segments to prevent exchanges or communication that could lead to ethical conflicts.
    ///     In such a case, an attempt to send a sign request based on a template that lists signers in conflicting segments will result in an error.
    ///     
    ///     Read more about [segments and ethical walls](https://support.box.com/hc/en-us/articles/9920431507603-Understanding-Information-Barriers#h_01GFVJEHQA06N7XEZ4GCZ9GFAQ).
    ///   - additionalInfo: Additional information on which fields are required and which fields are not editable.
    ///   - readySignLink: Box's ready-sign link feature enables you to create a link to a signature request that you've created from a template. Use this link when you want to post a signature request on a public form — such as an email, social media post, or web page — without knowing who the signers will be. Note: The ready-sign link feature is limited to Enterprise Plus customers and not available to Box Verified Enterprises.
    ///   - customBranding: Custom branding applied to notifications
    ///     and signature requests.
    public init(type: SignTemplateTypeField? = nil, id: String? = nil, name: TriStateField<String> = nil, emailSubject: TriStateField<String> = nil, emailMessage: TriStateField<String> = nil, daysValid: TriStateField<Int64> = nil, parentFolder: FolderMini? = nil, sourceFiles: [FileMini]? = nil, areFieldsLocked: Bool? = nil, areOptionsLocked: Bool? = nil, areRecipientsLocked: Bool? = nil, areEmailSettingsLocked: Bool? = nil, areFilesLocked: Bool? = nil, signers: [TemplateSigner]? = nil, additionalInfo: SignTemplateAdditionalInfoField? = nil, readySignLink: TriStateField<SignTemplateReadySignLinkField> = nil, customBranding: TriStateField<SignTemplateCustomBrandingField> = nil) {
        self.type = type
        self.id = id
        self._name = CodableTriState(state: name)
        self._emailSubject = CodableTriState(state: emailSubject)
        self._emailMessage = CodableTriState(state: emailMessage)
        self._daysValid = CodableTriState(state: daysValid)
        self.parentFolder = parentFolder
        self.sourceFiles = sourceFiles
        self.areFieldsLocked = areFieldsLocked
        self.areOptionsLocked = areOptionsLocked
        self.areRecipientsLocked = areRecipientsLocked
        self.areEmailSettingsLocked = areEmailSettingsLocked
        self.areFilesLocked = areFilesLocked
        self.signers = signers
        self.additionalInfo = additionalInfo
        self._readySignLink = CodableTriState(state: readySignLink)
        self._customBranding = CodableTriState(state: customBranding)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(SignTemplateTypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        emailSubject = try container.decodeIfPresent(String.self, forKey: .emailSubject)
        emailMessage = try container.decodeIfPresent(String.self, forKey: .emailMessage)
        daysValid = try container.decodeIfPresent(Int64.self, forKey: .daysValid)
        parentFolder = try container.decodeIfPresent(FolderMini.self, forKey: .parentFolder)
        sourceFiles = try container.decodeIfPresent([FileMini].self, forKey: .sourceFiles)
        areFieldsLocked = try container.decodeIfPresent(Bool.self, forKey: .areFieldsLocked)
        areOptionsLocked = try container.decodeIfPresent(Bool.self, forKey: .areOptionsLocked)
        areRecipientsLocked = try container.decodeIfPresent(Bool.self, forKey: .areRecipientsLocked)
        areEmailSettingsLocked = try container.decodeIfPresent(Bool.self, forKey: .areEmailSettingsLocked)
        areFilesLocked = try container.decodeIfPresent(Bool.self, forKey: .areFilesLocked)
        signers = try container.decodeIfPresent([TemplateSigner].self, forKey: .signers)
        additionalInfo = try container.decodeIfPresent(SignTemplateAdditionalInfoField.self, forKey: .additionalInfo)
        readySignLink = try container.decodeIfPresent(SignTemplateReadySignLinkField.self, forKey: .readySignLink)
        customBranding = try container.decodeIfPresent(SignTemplateCustomBrandingField.self, forKey: .customBranding)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(field: _name.state, forKey: .name)
        try container.encode(field: _emailSubject.state, forKey: .emailSubject)
        try container.encode(field: _emailMessage.state, forKey: .emailMessage)
        try container.encode(field: _daysValid.state, forKey: .daysValid)
        try container.encodeIfPresent(parentFolder, forKey: .parentFolder)
        try container.encodeIfPresent(sourceFiles, forKey: .sourceFiles)
        try container.encodeIfPresent(areFieldsLocked, forKey: .areFieldsLocked)
        try container.encodeIfPresent(areOptionsLocked, forKey: .areOptionsLocked)
        try container.encodeIfPresent(areRecipientsLocked, forKey: .areRecipientsLocked)
        try container.encodeIfPresent(areEmailSettingsLocked, forKey: .areEmailSettingsLocked)
        try container.encodeIfPresent(areFilesLocked, forKey: .areFilesLocked)
        try container.encodeIfPresent(signers, forKey: .signers)
        try container.encodeIfPresent(additionalInfo, forKey: .additionalInfo)
        try container.encode(field: _readySignLink.state, forKey: .readySignLink)
        try container.encode(field: _customBranding.state, forKey: .customBranding)
    }

}
