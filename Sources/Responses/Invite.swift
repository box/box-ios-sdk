//
//  Invite.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/13/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Defines invitation for a user to join enterprise
public class Invite: BoxModel {
    // MARK: - BoxModel

    private static var resourceType: String = "invite"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let id: String
    /// Enterprise object user is invited to.
    public let invitedTo: Enterprise?
    /// The user who was invited to the enterprise
    public let actionableBy: User?
    /// User who created the invitation.
    public let invitedBy: User?
    /// Invitation status
    public let status: String?
    /// When invitation was created.
    public let createdAt: Date?
    /// When invitation was updated.
    public let modifiedAt: Date?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == Invite.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [Invite.resourceType]))
        }

        rawData = json
        type = itemType
        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        invitedTo = try BoxJSONDecoder.optionalDecode(json: json, forKey: "invited_to")
        actionableBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "actionable_by")
        invitedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "invited_by")
        status = try BoxJSONDecoder.optionalDecode(json: json, forKey: "status")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
    }
}
