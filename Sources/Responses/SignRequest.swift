//
//  SignRequest.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 08/10/2021.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

//    swiftlint:disable cyclomatic_complexity

/// Describes the status of the sign request.
public enum SignRequestStatus: BoxEnum {
    /// Converting status.
    case converting
    /// Created status.
    case created
    /// Sent status.
    case sent
    /// Viewed status.
    case viewed
    /// Signed status.
    case signed
    /// Cancelled status.
    case cancelled
    /// Declined status.
    case declined
    /// Error converting status.
    case errorConverting
    /// Error sending status.
    case errorSending
    /// Expired status.
    case expired
    /// Finalizing status.
    case finalizing
    /// Error finalizing status.
    case errorFinalizing
    /// Custom value for enum values not yet implemented in the SDK
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "converting":
            self = .converting
        case "created":
            self = .created
        case "sent":
            self = .sent
        case "viewed":
            self = .viewed
        case "signed":
            self = .signed
        case "cancelled":
            self = .cancelled
        case "declined":
            self = .declined
        case "error_converting":
            self = .errorConverting
        case "error_sending":
            self = .errorSending
        case "expired":
            self = .expired
        case "finalizing":
            self = .finalizing
        case "error_finalizing":
            self = .errorFinalizing
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .converting:
            return "converting"
        case .created:
            return "created"
        case .sent:
            return "sent"
        case .viewed:
            return "viewed"
        case .signed:
            return "signed"
        case .cancelled:
            return "cancelled"
        case .declined:
            return "declined"
        case .errorConverting:
            return "error_converting"
        case .errorSending:
            return "error_sending"
        case .expired:
            return "expired"
        case .finalizing:
            return "finalizing"
        case .errorFinalizing:
            return "error_finalizing"
        case let .customValue(value):
            return value
        }
    }
}

//    swiftlint:enable cyclomatic_complexity

/// A standard representation of a sign request, as returned from any Box Sign API endpoints by default.
public class SignRequest: BoxModel {

    // MARK: - BoxModel

    private static var resourceType: String = "sign-request"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Signers for the sign request.
    public let signers: [SignRequestSigner]
    /// Sign request ID
    public let id: String
    /// This URL is returned if  `isDocumentPreparationNeeded` is set to `true` in the request.
    /// It is used to prepare the sign request via UI.
    /// The sign request is not sent until preparation is complete.
    public let prepareUrl: String?
    /// Reference to a file that holds a log of all signer activity for the request.
    public let signingLog: File?
    /// Status of the sign request.
    public let status: SignRequestStatus?
    /// List of files that will be signed, which are copies of the original source files.
    /// A new version of these files are created as signers sign and can be downloaded at any point in the signing process.
    public let signFiles: SignRequestSignFiles?
    /// Uses `daysValid` to calculate the date and time, the sign request will expire if unsigned.
    public let autoExpireAt: Date?
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
    /// List of files to create a signing document from.
    public let sourceFiles: [File]
    /// The destination folder to place final, signed document and signing log.
    public let parentFolder: Folder
    /// List of prefill tags.
    public let prefillTags: [SignRequestPrefillTag]?
    /// Number of days after which this request will automatically expire if not completed.
    public let daysValid: Int?
    /// A reference ID in an external system that the sign request is related to.
    public let externalId: String?
    /// The URL that a signer will be redirected to after signing a document.
    public let redirectUrl: String?
    /// The URL that a signer will be redirected to after declined signing a document.
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
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {

        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == SignRequest.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [SignRequest.resourceType]))
        }

        rawData = json
        type = itemType
        signers = try BoxJSONDecoder.decodeCollection(json: json, forKey: "signers")
        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        prepareUrl = try BoxJSONDecoder.optionalDecode(json: json, forKey: "prepare_url")
        signingLog = try BoxJSONDecoder.optionalDecode(json: json, forKey: "signing_log")
        status = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "status")
        signFiles = try BoxJSONDecoder.optionalDecode(json: json, forKey: "sign_files")
        autoExpireAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "auto_expire_at")
        isDocumentPreparationNeeded = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_document_preparation_needed")
        areTextSignaturesEnabled = try BoxJSONDecoder.optionalDecode(json: json, forKey: "are_text_signatures_enabled")
        emailSubject = try BoxJSONDecoder.optionalDecode(json: json, forKey: "email_subject")
        emailMessage = try BoxJSONDecoder.optionalDecode(json: json, forKey: "email_message")
        areRemindersEnabled = try BoxJSONDecoder.optionalDecode(json: json, forKey: "are_reminders_enabled")
        sourceFiles = try BoxJSONDecoder.decodeCollection(json: json, forKey: "source_files")
        parentFolder = try BoxJSONDecoder.decode(json: json, forKey: "parent_folder")
        prefillTags = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "prefill_tags")
        daysValid = try BoxJSONDecoder.optionalDecode(json: json, forKey: "days_valid")
        externalId = try BoxJSONDecoder.optionalDecode(json: json, forKey: "external_id")
        redirectUrl = try BoxJSONDecoder.optionalDecode(json: json, forKey: "redirect_url")
        declinedRedirectUrl = try BoxJSONDecoder.optionalDecode(json: json, forKey: "declined_redirect_url")
        name = try BoxJSONDecoder.optionalDecode(json: json, forKey: "name")
        isPhoneVerificationRequiredToView = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_phone_verification_required_to_view")
        templateId = try BoxJSONDecoder.optionalDecode(json: json, forKey: "template_id")
        signatureColor = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "signature_color")
    }
}
