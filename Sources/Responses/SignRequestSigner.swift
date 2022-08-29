//
//  SignRequestSigner.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 08/10/2021.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

/// Defines the role of the signer in the sign request.
public enum SignRequestSignerRole: BoxEnum {
    /// Role needed  to sign the document.
    case signer
    /// Role needed to approve the document.
    case approver
    /// Role which receives the final signded document and signing log.
    case finalCopyReader
    /// Custom value for enum values not yet implemented in the SDK
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "signer":
            self = .signer
        case "approver":
            self = .approver
        case "final_copy_reader":
            self = .finalCopyReader
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .signer:
            return "signer"
        case .approver:
            return "approver"
        case .finalCopyReader:
            return "final_copy_reader"
        case let .customValue(value):
            return value
        }
    }
}

/// Represents a signer fields for GET Sign Request response.
public class SignRequestSigner: BoxModel {

    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

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
    /// Flag which indicating if signer has viewed the document.
    public let hasViewedDocument: Bool?
    /// Final decision made by the signer.
    public let signerDecision: SignRequestSignerDecision?
    /// Inputs created by a signer on a sign request.
    public let inputs: [SignRequestSignerInput]?
    /// URL to direct a signer to for signing.
    public let embedUrl: String?
    /// The URL that a signer will be redirected to after signing a document.
    public let redirectUrl: String?
    /// The URL that a signer will be redirect to after declining to sign a document.
    public let declinedRedirectUrl: String?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        email = try BoxJSONDecoder.decode(json: json, forKey: "email")
        role = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "role")
        isInPerson = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_in_person")
        order = try BoxJSONDecoder.optionalDecode(json: json, forKey: "order")
        embedUrlExternalUserId = try BoxJSONDecoder.optionalDecode(json: json, forKey: "embed_url_external_user_id")
        hasViewedDocument = try BoxJSONDecoder.optionalDecode(json: json, forKey: "has_viewed_document")
        signerDecision = try BoxJSONDecoder.optionalDecode(json: json, forKey: "signer_decision")
        inputs = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "inputs")
        embedUrl = try BoxJSONDecoder.optionalDecode(json: json, forKey: "embed_url")
        redirectUrl = try BoxJSONDecoder.optionalDecode(json: json, forKey: "redirect_url")
        declinedRedirectUrl = try BoxJSONDecoder.optionalDecode(json: json, forKey: "declined_redirect_url")
    }
}
