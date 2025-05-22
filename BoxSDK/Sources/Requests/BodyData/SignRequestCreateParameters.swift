//
//  SignRequestCreateParameters.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 08/10/2021.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

/// Represents a  file version of a file included in a sign request
public struct SignRequestCreateSourceFileVersion: Encodable {

    /// Resource type
    let type = "file_version"
    /// The ID of the file version object
    public let id: String

    /// Initializer.
    ///
    /// - Parameters:
    ///   - id: Identifier of the file version.
    public init(id: String) {
        self.id = id
    }
}

/// Represents a  file to be included in a sign request.
public struct SignRequestCreateSourceFile: Encodable {

    /// Resource type
    let type = "file"
    /// Identifier of the file
    public let id: String
    /// The version information of the file.
    public let fileVersion: SignRequestCreateSourceFileVersion?

    /// Initializer.
    ///
    /// - Parameters:
    ///   - id: Identifier of the file.
    ///   - fileVersionId: Identifier of the file version.
    public init(id: String, fileVersionId: String? = nil) {
        self.id = id

        if let fileVersionId = fileVersionId {
            fileVersion = SignRequestCreateSourceFileVersion(id: fileVersionId)
        }
        else {
            fileVersion = nil
        }
    }

    /// Initializer.
    ///
    /// - Parameters:
    ///   - file: The file that will be included in a sign request.
    public init(file: File) {
        id = file.id

        if let fileVersionId = file.fileVersion?.id {
            fileVersion = SignRequestCreateSourceFileVersion(id: fileVersionId)
        }
        else {
            fileVersion = nil
        }
    }
}

/// Represents a destination folder to place final, signed document and signing log.
public struct SignRequestCreateParentFolder: Encodable {

    /// Resource type
    let type = "folder"
    /// Identifier of the folder
    public let id: String

    /// Initializer.
    ///
    /// - Parameters:
    ///   - id: Identifier of the folder that will be used as a destination place.
    public init(id: String) {
        self.id = id
    }

    /// Initializer.
    ///
    /// - Parameters:
    ///   - folder: The folder that will be used as a destination place.
    public init(folder: Folder) {
        id = folder.id
    }
}

/// Defines a signer for Create Sign Request",
public struct SignRequestCreateSigner: Encodable {

    /// Email address of the signer
    public let email: String
    /// Role of the signer
    public let role: SignRequestSignerRole?
    /// Used in combination with an embed URL for a sender. After the sender signs, they will be redirected to the next `inPerson` signer.
    public let isInPerson: Bool?
    /// Order of the signer.
    public let order: Int?
    /// User ID for the signer in an external application responsible for authentication when accessing the embed URL.
    public let embedUrlExternalUserId: String?
    /// The URL that the signer will be redirected to after signing.
    public let redirectUrl: String?
    /// The URL that a signer will be redirect to after declining to sign a document.
    public let declinedRedirectUrl: String?
    /// If set to true, signer will need to login to a Box account before signing the request.
    /// If the signer does not have an existing account, they will have an option to create a free Box account.
    public let loginRequired: Bool?
    /// If set, this phone number is be used to verify the signer via two factor authentication before they are able to sign the document.
    public let verificationPhoneNumber: String?
    /// If set, the signer is required to enter the password before they are able to sign a document. This field is write only.
    public let password: String?
    /// If set, signers who have the same value will be assigned to the same input and to the same signer group.
    /// A signer group is expected to have more than one signer.
    /// If the provided value is only used for one signer, this value will be ignored and request will be handled
    /// as it was intended for an individual signer. The value provided can be any string and only used to
    /// determine which signers belongs to same group. A successful response will provide a generated UUID value
    /// instead for signers in the same signer group.
    public let signerGroupId: String?

    /// Initializer.
    ///
    /// - Parameters:
    ///   - email: Email address of the signer.
    ///   - role: Role of the signer.
    ///   - isInPerson: flag that is used in combination with an embed url for a sender.
    ///   After the sender signs, they will be redirected to the next `inPerson` signer.
    ///   - order: Order of the signer.
    ///   - embedUrlExternalUserId: User ID for the signer in an external application responsible for authentication when accessing the embed URL.
    ///   - redirectUrl: The URL that the signer will be redirected to after signing.
    ///   - declinedRedirectUrl: The URL that a signer will be redirect to after declining to sign a document.
    ///   - loginRequired: If set to true, signer will need to login to a Box account before signing the request.
    ///   If the signer does not have an existing account, they will have an option to create a free Box account.
    ///   - verificationPhoneNumber: If set, the signer is required to enter the password before they are able to sign a document. This field is write only.
    ///   - password: If set, the signer is required to enter the password before they are able to sign a document. This field is write only.
    ///   - signerGroupId: If set, signers who have the same value will be assigned to the same input and to the same signer group.
    ///   A signer group is expected to have more than one signer.
    public init(
        email: String,
        role: SignRequestSignerRole? = nil,
        isInPerson: Bool? = nil,
        order: Int? = nil,
        embedUrlExternalUserId: String? = nil,
        redirectUrl: String? = nil,
        declinedRedirectUrl: String? = nil,
        loginRequired: Bool? = nil,
        verificationPhoneNumber: String? = nil,
        password: String? = nil,
        signerGroupId: String? = nil
    ) {
        self.email = email
        self.role = role
        self.isInPerson = isInPerson
        self.order = order
        self.embedUrlExternalUserId = embedUrlExternalUserId
        self.redirectUrl = redirectUrl
        self.declinedRedirectUrl = declinedRedirectUrl
        self.loginRequired = loginRequired
        self.verificationPhoneNumber = verificationPhoneNumber
        self.password = password
        self.signerGroupId = signerGroupId
    }
}

/// Defines a request to creatre a sign request object.
public struct SignRequestCreateParameters: Encodable {

    /// Indicates if the sender should receive a `prepareUrl` in the response to complete document preparation via UI.
    public let isDocumentPreparationNeeded: Bool?
    /// Disables the usage of signatures generated by typing (text). Default is true.
    public let areTextSignaturesEnabled: Bool?
    /// Subject of sign request email. This is cleaned by sign request. If this field is not passed, a default subject will be used.
    public let emailSubject: String?
    /// Message to include in sign request email. The field is cleaned through sanitization of specific characters.
    /// However, some html tags are allowed. Links included in the message are also converted to hyperlinks in the email.
    /// The message may contain the following html tags including :
    /// `a`, `abbr`, `acronym`, `b`, `blockquote`, `code`, `em`, `i`, `ul`, `li`, `ol`, and `strong`.
    /// Be aware that when the text to html ratio is too high, the email may end up in spam filters.
    /// Custom styles on these tags are not allowed. If this field is not passed, a default message will be used.
    public let emailMessage: String?
    /// Flag indicating if remind signers to sign a document on day 3, 8, 13 and 18. Reminders are only sent to outstanding signers.
    public let areRemindersEnabled: Bool?
    /// List of prefill tags.
    /// When a document contains sign related tags in the content, you can prefill them using this `prefillTags`
    /// by referencing the `id` of the tag as the `externalId` field of the prefill tag.
    public let prefillTags: [SignRequestPrefillTag]?
    /// Number of days after which this request will automatically expire if not completed.
    public let daysValid: Int?
    /// This can be used to reference an ID in an external system that the sign request is related to.
    public let externalId: String?
    /// The URL that a signer will be redirected to after signing a document.
    public let redirectUrl: String?
    /// The URL that the signer will be redirected to after declining to sign a document.
    public let declinedRedirectUrl: String?
    /// Name of the sign request.
    public let name: String?
    /// Forces signers to verify a text message prior to viewing the document. You must specify the phone number of signers to have this setting apply to them.
    public let isPhoneVerificationRequiredToView: Bool?
    /// When a signature request is created from a template this field will indicate the id of that template.
    public let templateId: String?
    /// Specific color for the signature (blue, black, or red).
    public let signatureColor: SignRequestSignatureColor?

    /// Initializer.
    ///
    /// - Parameters:
    ///   - isDocumentPreparationNeeded: Indicates if the sender should receive a `prepareUrl` in the response to complete document preparation via UI.
    ///   - areTextSignaturesEnabled: Disables the usage of signatures generated by typing (text).
    ///   - emailSubject: Subject of sign request email.
    ///   - emailMessage: Message to include in sign request email.
    ///   - areRemindersEnabled: Flag indicating if remind signers to sign a document on day 3, 8, 13 and 18.
    ///   - prefillTags: List of prefill tags.
    ///   - daysValid: Number of days after which this request will automatically expire if not completed.
    ///   - externalId: ID that serve as reference in an external system that the sign request is related to.
    ///   - redirectUrl: The URL that a signer will be redirected to after signing a document.
    ///   - declinedRedirectUrl: The URL that the signer will be redirected to after declining to sign a document.
    ///   - name: Name of the sign request.
    ///   - isPhoneVerificationRequiredToView: Forces signers to verify a text message prior to viewing the document. You must specify the phone number of signers to have this setting apply to them.
    ///   - templateId: When a signature request is created from a template this field will indicate the id of that template.
    ///   - signatureColor: Force a specific color for the signature (blue, black, or red).
    public init(
        isDocumentPreparationNeeded: Bool? = nil,
        areTextSignaturesEnabled: Bool? = nil,
        emailSubject: String? = nil,
        emailMessage: String? = nil,
        areRemindersEnabled: Bool? = nil,
        prefillTags: [SignRequestPrefillTag]? = nil,
        daysValid: Int? = nil,
        externalId: String? = nil,
        redirectUrl: String? = nil,
        declinedRedirectUrl: String? = nil,
        name: String? = nil,
        isPhoneVerificationRequiredToView: Bool? = nil,
        templateId: String? = nil,
        signatureColor: SignRequestSignatureColor? = nil
    ) {
        self.isDocumentPreparationNeeded = isDocumentPreparationNeeded
        self.areTextSignaturesEnabled = areTextSignaturesEnabled
        self.emailSubject = emailSubject
        self.emailMessage = emailMessage
        self.areRemindersEnabled = areRemindersEnabled
        self.prefillTags = prefillTags
        self.daysValid = daysValid
        self.externalId = externalId
        self.redirectUrl = redirectUrl
        self.declinedRedirectUrl = declinedRedirectUrl
        self.name = name
        self.isPhoneVerificationRequiredToView = isPhoneVerificationRequiredToView
        self.templateId = templateId
        self.signatureColor = signatureColor
    }
}
