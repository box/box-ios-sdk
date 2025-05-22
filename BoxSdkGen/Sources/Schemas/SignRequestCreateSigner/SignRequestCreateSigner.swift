import Foundation

/// The schema for a Signer object used in
/// for creating a Box Sign request object.
public class SignRequestCreateSigner: Codable {
    private enum CodingKeys: String, CodingKey {
        case email
        case role
        case isInPerson = "is_in_person"
        case order
        case embedUrlExternalUserId = "embed_url_external_user_id"
        case redirectUrl = "redirect_url"
        case declinedRedirectUrl = "declined_redirect_url"
        case loginRequired = "login_required"
        case verificationPhoneNumber = "verification_phone_number"
        case password
        case signerGroupId = "signer_group_id"
        case suppressNotifications = "suppress_notifications"
    }

    /// Email address of the signer.
    /// The email address of the signer is required when making signature requests, except when using templates that are configured to include emails.
    @CodableTriState public private(set) var email: String?

    /// Defines the role of the signer in the signature request. A `signer`
    /// must sign the document and an `approver` must approve the document. A
    /// `final_copy_reader` only receives the final signed document and signing
    /// log.
    public let role: SignRequestCreateSignerRoleField?

    /// Used in combination with an embed URL for a sender. After the
    /// sender signs, they are redirected to the next `in_person` signer.
    public let isInPerson: Bool?

    /// Order of the signer
    public let order: Int64?

    /// User ID for the signer in an external application responsible
    /// for authentication when accessing the embed URL.
    @CodableTriState public private(set) var embedUrlExternalUserId: String?

    /// The URL that a signer will be redirected
    /// to after signing a document. Defining this URL
    /// overrides default or global redirect URL
    /// settings for a specific signer.
    /// If no declined redirect URL is specified,
    /// this URL will be used for decline actions as well.
    @CodableTriState public private(set) var redirectUrl: String?

    /// The URL that a signer will be redirect
    /// to after declining to sign a document.
    /// Defining this URL overrides default or global
    /// declined redirect URL settings for a specific signer.
    @CodableTriState public private(set) var declinedRedirectUrl: String?

    /// If set to true, the signer will need to log in to a Box account
    /// before signing the request. If the signer does not have
    /// an existing account, they will have the option to create
    /// a free Box account.
    @CodableTriState public private(set) var loginRequired: Bool?

    /// If set, this phone number will be used to verify the signer
    /// via two-factor authentication before they are able to sign the document.
    /// Cannot be selected in combination with `login_required`.
    @CodableTriState public private(set) var verificationPhoneNumber: String?

    /// If set, the signer is required to enter the password before they are able
    /// to sign a document. This field is write only.
    @CodableTriState public private(set) var password: String?

    /// If set, signers who have the same value will be assigned to the same input and to the same signer group.
    /// A signer group is not a Box Group. It is an entity that belongs to a Sign Request and can only be
    /// used/accessed within this Sign Request. A signer group is expected to have more than one signer.
    /// If the provided value is only used for one signer, this value will be ignored and request will be handled
    /// as it was intended for an individual signer. The value provided can be any string and only used to
    /// determine which signers belongs to same group. A successful response will provide a generated UUID value
    /// instead for signers in the same signer group.
    @CodableTriState public private(set) var signerGroupId: String?

    /// If true, no emails about the sign request will be sent
    @CodableTriState public private(set) var suppressNotifications: Bool?

    /// Initializer for a SignRequestCreateSigner.
    ///
    /// - Parameters:
    ///   - email: Email address of the signer.
    ///     The email address of the signer is required when making signature requests, except when using templates that are configured to include emails.
    ///   - role: Defines the role of the signer in the signature request. A `signer`
    ///     must sign the document and an `approver` must approve the document. A
    ///     `final_copy_reader` only receives the final signed document and signing
    ///     log.
    ///   - isInPerson: Used in combination with an embed URL for a sender. After the
    ///     sender signs, they are redirected to the next `in_person` signer.
    ///   - order: Order of the signer
    ///   - embedUrlExternalUserId: User ID for the signer in an external application responsible
    ///     for authentication when accessing the embed URL.
    ///   - redirectUrl: The URL that a signer will be redirected
    ///     to after signing a document. Defining this URL
    ///     overrides default or global redirect URL
    ///     settings for a specific signer.
    ///     If no declined redirect URL is specified,
    ///     this URL will be used for decline actions as well.
    ///   - declinedRedirectUrl: The URL that a signer will be redirect
    ///     to after declining to sign a document.
    ///     Defining this URL overrides default or global
    ///     declined redirect URL settings for a specific signer.
    ///   - loginRequired: If set to true, the signer will need to log in to a Box account
    ///     before signing the request. If the signer does not have
    ///     an existing account, they will have the option to create
    ///     a free Box account.
    ///   - verificationPhoneNumber: If set, this phone number will be used to verify the signer
    ///     via two-factor authentication before they are able to sign the document.
    ///     Cannot be selected in combination with `login_required`.
    ///   - password: If set, the signer is required to enter the password before they are able
    ///     to sign a document. This field is write only.
    ///   - signerGroupId: If set, signers who have the same value will be assigned to the same input and to the same signer group.
    ///     A signer group is not a Box Group. It is an entity that belongs to a Sign Request and can only be
    ///     used/accessed within this Sign Request. A signer group is expected to have more than one signer.
    ///     If the provided value is only used for one signer, this value will be ignored and request will be handled
    ///     as it was intended for an individual signer. The value provided can be any string and only used to
    ///     determine which signers belongs to same group. A successful response will provide a generated UUID value
    ///     instead for signers in the same signer group.
    ///   - suppressNotifications: If true, no emails about the sign request will be sent
    public init(email: TriStateField<String> = nil, role: SignRequestCreateSignerRoleField? = nil, isInPerson: Bool? = nil, order: Int64? = nil, embedUrlExternalUserId: TriStateField<String> = nil, redirectUrl: TriStateField<String> = nil, declinedRedirectUrl: TriStateField<String> = nil, loginRequired: TriStateField<Bool> = nil, verificationPhoneNumber: TriStateField<String> = nil, password: TriStateField<String> = nil, signerGroupId: TriStateField<String> = nil, suppressNotifications: TriStateField<Bool> = nil) {
        self._email = CodableTriState(state: email)
        self.role = role
        self.isInPerson = isInPerson
        self.order = order
        self._embedUrlExternalUserId = CodableTriState(state: embedUrlExternalUserId)
        self._redirectUrl = CodableTriState(state: redirectUrl)
        self._declinedRedirectUrl = CodableTriState(state: declinedRedirectUrl)
        self._loginRequired = CodableTriState(state: loginRequired)
        self._verificationPhoneNumber = CodableTriState(state: verificationPhoneNumber)
        self._password = CodableTriState(state: password)
        self._signerGroupId = CodableTriState(state: signerGroupId)
        self._suppressNotifications = CodableTriState(state: suppressNotifications)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        role = try container.decodeIfPresent(SignRequestCreateSignerRoleField.self, forKey: .role)
        isInPerson = try container.decodeIfPresent(Bool.self, forKey: .isInPerson)
        order = try container.decodeIfPresent(Int64.self, forKey: .order)
        embedUrlExternalUserId = try container.decodeIfPresent(String.self, forKey: .embedUrlExternalUserId)
        redirectUrl = try container.decodeIfPresent(String.self, forKey: .redirectUrl)
        declinedRedirectUrl = try container.decodeIfPresent(String.self, forKey: .declinedRedirectUrl)
        loginRequired = try container.decodeIfPresent(Bool.self, forKey: .loginRequired)
        verificationPhoneNumber = try container.decodeIfPresent(String.self, forKey: .verificationPhoneNumber)
        password = try container.decodeIfPresent(String.self, forKey: .password)
        signerGroupId = try container.decodeIfPresent(String.self, forKey: .signerGroupId)
        suppressNotifications = try container.decodeIfPresent(Bool.self, forKey: .suppressNotifications)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _email.state, forKey: .email)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeIfPresent(isInPerson, forKey: .isInPerson)
        try container.encodeIfPresent(order, forKey: .order)
        try container.encode(field: _embedUrlExternalUserId.state, forKey: .embedUrlExternalUserId)
        try container.encode(field: _redirectUrl.state, forKey: .redirectUrl)
        try container.encode(field: _declinedRedirectUrl.state, forKey: .declinedRedirectUrl)
        try container.encode(field: _loginRequired.state, forKey: .loginRequired)
        try container.encode(field: _verificationPhoneNumber.state, forKey: .verificationPhoneNumber)
        try container.encode(field: _password.state, forKey: .password)
        try container.encode(field: _signerGroupId.state, forKey: .signerGroupId)
        try container.encode(field: _suppressNotifications.state, forKey: .suppressNotifications)
    }

}
