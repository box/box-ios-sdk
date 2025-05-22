import Foundation

/// The schema for a Signer for Templates
public class TemplateSigner: Codable {
    private enum CodingKeys: String, CodingKey {
        case inputs
        case email
        case role
        case isInPerson = "is_in_person"
        case order
        case signerGroupId = "signer_group_id"
        case label
        case publicId = "public_id"
        case isPasswordRequired = "is_password_required"
        case isPhoneNumberRequired = "is_phone_number_required"
        case loginRequired = "login_required"
    }

    public let inputs: [TemplateSignerInput]?

    /// Email address of the signer
    @CodableTriState public private(set) var email: String?

    /// Defines the role of the signer in the signature request. A role of
    /// `signer` needs to sign the document, a role `approver`
    /// approves the document and
    /// a `final_copy_reader` role only
    /// receives the final signed document and signing log.
    public let role: TemplateSignerRoleField?

    /// Used in combination with an embed URL for a sender.
    /// After the sender signs, they will be
    /// redirected to the next `in_person` signer.
    public let isInPerson: Bool?

    /// Order of the signer
    public let order: Int64?

    /// If provided, this value points signers that are assigned the same inputs and belongs to same signer group.
    /// A signer group is not a Box Group. It is an entity that belongs to the template itself and can only be used
    /// within Box Sign requests created from it.
    @CodableTriState public private(set) var signerGroupId: String?

    /// A placeholder label for the signer set by the template creator to differentiate between signers.
    @CodableTriState public private(set) var label: String?

    /// An identifier for the signer. This can be used to identify a signer within the template.
    public let publicId: String?

    /// If true for signers with a defined email, the password provided when the template was created is used by default. 
    /// If true for signers without a specified / defined email, the creator needs to provide a password when using the template.
    @CodableTriState public private(set) var isPasswordRequired: Bool?

    /// If true for signers with a defined email, the phone number provided when the template was created is used by default. 
    /// If true for signers without a specified / defined email, the template creator needs to provide a phone number when creating a request.
    @CodableTriState public private(set) var isPhoneNumberRequired: Bool?

    /// If true, the signer is required to login to access the document.
    @CodableTriState public private(set) var loginRequired: Bool?

    /// Initializer for a TemplateSigner.
    ///
    /// - Parameters:
    ///   - inputs: 
    ///   - email: Email address of the signer
    ///   - role: Defines the role of the signer in the signature request. A role of
    ///     `signer` needs to sign the document, a role `approver`
    ///     approves the document and
    ///     a `final_copy_reader` role only
    ///     receives the final signed document and signing log.
    ///   - isInPerson: Used in combination with an embed URL for a sender.
    ///     After the sender signs, they will be
    ///     redirected to the next `in_person` signer.
    ///   - order: Order of the signer
    ///   - signerGroupId: If provided, this value points signers that are assigned the same inputs and belongs to same signer group.
    ///     A signer group is not a Box Group. It is an entity that belongs to the template itself and can only be used
    ///     within Box Sign requests created from it.
    ///   - label: A placeholder label for the signer set by the template creator to differentiate between signers.
    ///   - publicId: An identifier for the signer. This can be used to identify a signer within the template.
    ///   - isPasswordRequired: If true for signers with a defined email, the password provided when the template was created is used by default. 
    ///     If true for signers without a specified / defined email, the creator needs to provide a password when using the template.
    ///   - isPhoneNumberRequired: If true for signers with a defined email, the phone number provided when the template was created is used by default. 
    ///     If true for signers without a specified / defined email, the template creator needs to provide a phone number when creating a request.
    ///   - loginRequired: If true, the signer is required to login to access the document.
    public init(inputs: [TemplateSignerInput]? = nil, email: TriStateField<String> = nil, role: TemplateSignerRoleField? = nil, isInPerson: Bool? = nil, order: Int64? = nil, signerGroupId: TriStateField<String> = nil, label: TriStateField<String> = nil, publicId: String? = nil, isPasswordRequired: TriStateField<Bool> = nil, isPhoneNumberRequired: TriStateField<Bool> = nil, loginRequired: TriStateField<Bool> = nil) {
        self.inputs = inputs
        self._email = CodableTriState(state: email)
        self.role = role
        self.isInPerson = isInPerson
        self.order = order
        self._signerGroupId = CodableTriState(state: signerGroupId)
        self._label = CodableTriState(state: label)
        self.publicId = publicId
        self._isPasswordRequired = CodableTriState(state: isPasswordRequired)
        self._isPhoneNumberRequired = CodableTriState(state: isPhoneNumberRequired)
        self._loginRequired = CodableTriState(state: loginRequired)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        inputs = try container.decodeIfPresent([TemplateSignerInput].self, forKey: .inputs)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        role = try container.decodeIfPresent(TemplateSignerRoleField.self, forKey: .role)
        isInPerson = try container.decodeIfPresent(Bool.self, forKey: .isInPerson)
        order = try container.decodeIfPresent(Int64.self, forKey: .order)
        signerGroupId = try container.decodeIfPresent(String.self, forKey: .signerGroupId)
        label = try container.decodeIfPresent(String.self, forKey: .label)
        publicId = try container.decodeIfPresent(String.self, forKey: .publicId)
        isPasswordRequired = try container.decodeIfPresent(Bool.self, forKey: .isPasswordRequired)
        isPhoneNumberRequired = try container.decodeIfPresent(Bool.self, forKey: .isPhoneNumberRequired)
        loginRequired = try container.decodeIfPresent(Bool.self, forKey: .loginRequired)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(inputs, forKey: .inputs)
        try container.encode(field: _email.state, forKey: .email)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeIfPresent(isInPerson, forKey: .isInPerson)
        try container.encodeIfPresent(order, forKey: .order)
        try container.encode(field: _signerGroupId.state, forKey: .signerGroupId)
        try container.encode(field: _label.state, forKey: .label)
        try container.encodeIfPresent(publicId, forKey: .publicId)
        try container.encode(field: _isPasswordRequired.state, forKey: .isPasswordRequired)
        try container.encode(field: _isPhoneNumberRequired.state, forKey: .isPhoneNumberRequired)
        try container.encode(field: _loginRequired.state, forKey: .loginRequired)
    }

}
