import Foundation

/// The schema for a Signer object used
/// on the body of a Box Sign request object.
public class SignRequestSigner: SignRequestCreateSigner {
    private enum CodingKeys: String, CodingKey {
        case hasViewedDocument = "has_viewed_document"
        case signerDecision = "signer_decision"
        case inputs
        case embedUrl = "embed_url"
        case iframeableEmbedUrl = "iframeable_embed_url"
    }

    /// Set to `true` if the signer views the document
    public let hasViewedDocument: Bool?

    /// Final decision made by the signer.
    @CodableTriState public private(set) var signerDecision: SignRequestSignerSignerDecisionField?

    public let inputs: [SignRequestSignerInput]?

    /// URL to direct a signer to for signing
    @CodableTriState public private(set) var embedUrl: String?

    /// This URL is specifically designed for
    /// signing documents within an HTML `iframe` tag.
    /// It will be returned in the response
    /// only if the `embed_url_external_user_id`
    /// parameter was passed in the
    /// `create Box Sign request` call.
    @CodableTriState public private(set) var iframeableEmbedUrl: String?

    /// Initializer for a SignRequestSigner.
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
    ///   - hasViewedDocument: Set to `true` if the signer views the document
    ///   - signerDecision: Final decision made by the signer.
    ///   - inputs: 
    ///   - embedUrl: URL to direct a signer to for signing
    ///   - iframeableEmbedUrl: This URL is specifically designed for
    ///     signing documents within an HTML `iframe` tag.
    ///     It will be returned in the response
    ///     only if the `embed_url_external_user_id`
    ///     parameter was passed in the
    ///     `create Box Sign request` call.
    public init(email: TriStateField<String> = nil, role: SignRequestCreateSignerRoleField? = nil, isInPerson: Bool? = nil, order: Int64? = nil, embedUrlExternalUserId: TriStateField<String> = nil, redirectUrl: TriStateField<String> = nil, declinedRedirectUrl: TriStateField<String> = nil, loginRequired: TriStateField<Bool> = nil, verificationPhoneNumber: TriStateField<String> = nil, password: TriStateField<String> = nil, signerGroupId: TriStateField<String> = nil, suppressNotifications: TriStateField<Bool> = nil, hasViewedDocument: Bool? = nil, signerDecision: TriStateField<SignRequestSignerSignerDecisionField> = nil, inputs: [SignRequestSignerInput]? = nil, embedUrl: TriStateField<String> = nil, iframeableEmbedUrl: TriStateField<String> = nil) {
        self.hasViewedDocument = hasViewedDocument
        self._signerDecision = CodableTriState(state: signerDecision)
        self.inputs = inputs
        self._embedUrl = CodableTriState(state: embedUrl)
        self._iframeableEmbedUrl = CodableTriState(state: iframeableEmbedUrl)

        super.init(email: email, role: role, isInPerson: isInPerson, order: order, embedUrlExternalUserId: embedUrlExternalUserId, redirectUrl: redirectUrl, declinedRedirectUrl: declinedRedirectUrl, loginRequired: loginRequired, verificationPhoneNumber: verificationPhoneNumber, password: password, signerGroupId: signerGroupId, suppressNotifications: suppressNotifications)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasViewedDocument = try container.decodeIfPresent(Bool.self, forKey: .hasViewedDocument)
        signerDecision = try container.decodeIfPresent(SignRequestSignerSignerDecisionField.self, forKey: .signerDecision)
        inputs = try container.decodeIfPresent([SignRequestSignerInput].self, forKey: .inputs)
        embedUrl = try container.decodeIfPresent(String.self, forKey: .embedUrl)
        iframeableEmbedUrl = try container.decodeIfPresent(String.self, forKey: .iframeableEmbedUrl)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(hasViewedDocument, forKey: .hasViewedDocument)
        try container.encode(field: _signerDecision.state, forKey: .signerDecision)
        try container.encodeIfPresent(inputs, forKey: .inputs)
        try container.encode(field: _embedUrl.state, forKey: .embedUrl)
        try container.encode(field: _iframeableEmbedUrl.state, forKey: .iframeableEmbedUrl)
        try super.encode(to: encoder)
    }

}
