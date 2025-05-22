//
//  Collaboration.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/21/19.
//  Copyright © 2019 Box. All rights reserved.
//
import Foundation

/// The status of the collaboration invitation.
public enum CollaborationStatus: BoxEnum {
    /// Collaboration invitation accepted
    case accepted
    /// Collaboration invitation is pending
    case pending
    /// Collaboration invitation was rejected
    case rejected
    /// Collaboration invitation status of custom value that was not yet implemented in this version of SDK.
    case customValue(String)

    /// Initializer.
    ///
    /// - Parameter value: String representation of collaboration status.
    public init(_ value: String) {
        switch value {
        case "accepted":
            self = .accepted
        case "pending":
            self = .pending
        case "rejected":
            self = .rejected
        default:
            self = .customValue(value)
        }
    }

    /// String representation of collaboration status.
    public var description: String {

        switch self {
        case .accepted:
            return "accepted"
        case .pending:
            return "pending"
        case .rejected:
            return "rejected"
        case let .customValue(userValue):
            return userValue
        }
    }
}

// swiftlint:disable:next line_length
/// The level of access granted. To see exactly which role has which permission, please look [here](https://community.box.com/t5/Collaboration-and-Sharing/What-Are-The-Different-Access-Levels-For-Collaborators/ta-p/144)
public enum CollaborationRole: BoxEnum {
    /// Editor role
    case editor
    /// Viewer role
    case viewer
    /// Previewer rle
    case previewer
    /// Uploader role
    case uploader
    /// Preview uploader role
    case previewerUploader
    /// Viewer uploader role
    case viewerUploader
    /// Co-owner role
    case coOwner
    /// Owner role
    case owner
    /// Custom value of a role that was not yet implemented in this versison of SDK.
    case customValue(String)

    /// Initializer.
    ///
    /// - Parameter value: String representation of role
    public init(_ value: String) {
        switch value {
        case "editor":
            self = .editor
        case "viewer":
            self = .viewer
        case "previewer":
            self = .previewer
        case "uploader":
            self = .uploader
        case "previewer uploader":
            self = .previewerUploader
        case "viewer uploader":
            self = .viewerUploader
        case "co-owner":
            self = .coOwner
        case "owner":
            self = .owner
        default:
            self = .customValue(value)
        }
    }

    /// String representation of role
    public var description: String {
        switch self {
        case .editor:
            return "editor"
        case .viewer:
            return "viewer"
        case .previewer:
            return "previewer"
        case .uploader:
            return "uploader"
        case .previewerUploader:
            return "previewer uploader"
        case .viewerUploader:
            return "viewer uploader"
        case .coOwner:
            return "co-owner"
        case .owner:
            return "owner"
        case let .customValue(value):
            return value
        }
    }
}

/// Defines access permissions for users and groups to files and folders, similar to access control lists.
/// A collaboration object grants a user or group access to a file or folder with permissions defined by a specific role.
public class Collaboration: BoxModel {

    private static var resourceType: String = "collaboration"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let id: String
    /// The user who created the collaboration object.
    public let createdBy: User?
    /// When the collaboration object was created.
    public let createdAt: Date?
    /// When the collaboration object was last modified.
    public let modifiedAt: Date?
    /// When the collaboration will expire.
    public let expiresAt: Date?
    /// The status of the collaboration invitation.
    public let status: CollaborationStatus?
    /// The user or group that is granted access.
    public let accessibleBy: Collaborator?
    /// The level of access granted.
    public let role: CollaborationRole?
    /// When the status of the collaboration object changed to accepted or rejected.
    public let acknowledgedAt: Date?
    /// The file or folder that access is granted to
    public let item: CollaborationItem?
    /// The email address used to invite an un-registered collaborator, if they are not a registered user.
    public let inviteEmail: String?
    /// Whether the "view path collaboration" feature is enabled or not.
    /// View path collaborations allow the invitee to see the entire parent path to the item.
    /// View path collaboration does not grant privileges in any parent folder (e.g. cannot see content the user is not collaborated on),
    /// other than the permission to view the parent path.
    public let canViewPath: Bool?
    /// The acceptance requirements for the user or enterprise.
    public let acceptanceRequirementsStatus: AcceptanceRequirementsStatus?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == Collaboration.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [Collaboration.resourceType]))
        }

        rawData = json
        type = itemType
        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        createdBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "created_by")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
        expiresAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "expires_at")
        status = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "status")
        accessibleBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "accessible_by")
        role = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "role")
        acknowledgedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "acknowledged_at")
        item = try BoxJSONDecoder.optionalDecode(json: json, forKey: "item")
        inviteEmail = try BoxJSONDecoder.optionalDecode(json: json, forKey: "invite_email")
        canViewPath = try BoxJSONDecoder.optionalDecode(json: json, forKey: "can_view_path")
        acceptanceRequirementsStatus = try BoxJSONDecoder.optionalDecode(json: json, forKey: "acceptance_requirements_status")
    }

    /// Defines the Acceptance Requirements Status object.
    public class AcceptanceRequirementsStatus: BoxModel {

        public private(set) var rawData: [String: Any]

        // MARK: - Properties
        /// The requirements for Terms of Service part of Acceptance Requirements Status object.
        public let termsOfServiceRequirement: TermsOfServiceRequirement
        /// The requirements for Strong Password part of Acceptance Requirements Status object.
        public let strongPasswordRequirement: StrongPasswordRequirement
        /// The requirements for Two Factor Authentication part of Acceptance Requirements Status object.
        public let twoFactorAuthenticationRequirement: TwoFactorAuthenticationRequirement

        /// Initializer.
        ///
        /// - Parameter json: JSON dictionary.
        /// - Throws: Decoding error.
        public required init(json: [String: Any]) throws {
            rawData = json
            termsOfServiceRequirement = try BoxJSONDecoder.decode(json: json, forKey: "terms_of_service_requirement")
            strongPasswordRequirement = try BoxJSONDecoder.decode(json: json, forKey: "strong_password_requirement")
            twoFactorAuthenticationRequirement = try BoxJSONDecoder.decode(json: json, forKey: "two_factor_authentication_requirement")
        }
    }

    /// Defines the Terms of Service requirement for the Acceptance Requirements object.
    public class TermsOfServiceRequirement: BoxModel {

        public private(set) var rawData: [String: Any]

        // MARK: - Properties
        /// Indicator for whether or not the Terms of Service has been accepted.
        public let isAccepted: Bool
        /// The Terms of Service associated with the requirement status.
        public let termsOfService: TermsOfService

        /// Initializer.
        ///
        /// - Parameter json: JSON dictionary.
        /// - Throws: Decoding error.
        public required init(json: [String: Any]) throws {
            rawData = json
            isAccepted = try BoxJSONDecoder.decode(json: json, forKey: "is_accepted")
            termsOfService = try BoxJSONDecoder.decode(json: json, forKey: "terms_of_service")
        }
    }

    /// Defines the Strong Password requirement for the Acceptance Requirements object.
    public class StrongPasswordRequirement: BoxModel {

        public private(set) var rawData: [String: Any]

        // MARK: - Properties
        /// Indicator for whether the current enterprise has strong password enabled for users external
        /// current enterprise.
        public let strongPasswordRequiredForExternalUsers: Bool
        /// Indicator for whether the user has strong password enabled.
        public let userHasStrongPassword: Bool

        /// Initializer.
        ///
        /// - Parameter json: JSON dictionary.
        /// - Throws: Decoding error.
        public required init(json: [String: Any]) throws {
            rawData = json
            strongPasswordRequiredForExternalUsers = try BoxJSONDecoder.decode(
                json: json,
                forKey: "enterprise_has_strong_password_required_for_external_users"
            )
            userHasStrongPassword = try BoxJSONDecoder.decode(json: json, forKey: "user_has_strong_password")
        }
    }

    /// Defines the Two Factor Authentication Requirement for Acceptance Requirements object.
    public class TwoFactorAuthenticationRequirement: BoxModel {

        public private(set) var rawData: [String: Any]

        // MARK: - Properties
        /// Indicator for whether the enterpise has two factor authentication enabled.
        public let enterpriseHasTwoFactorAuthEnabled: Bool
        /// Indicator for whether the user has two factor authentication enabled.
        public let userHasTwoFactorAuthenticationEnabled: Bool

        /// Initializer.
        ///
        /// - Parameter json: JSON dictionary.
        /// - Throws: Decoding error.
        public required init(json: [String: Any]) throws {
            rawData = json
            enterpriseHasTwoFactorAuthEnabled = try BoxJSONDecoder.decode(json: json, forKey: "enterprise_has_two_factor_auth_enabled")
            userHasTwoFactorAuthenticationEnabled = try BoxJSONDecoder.decode(json: json, forKey: "user_has_two_factor_authentication_enabled")
        }
    }
}
