//
//  CollaborationWhitelistExemptTarget.swift
//  BoxSDK
//
//  Created by Daniel Cech on 8/29/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// The record that represents a target (at the moment, only users are supported as targets)
/// that is exempt from the collaboration whitelist.
public class CollaborationWhitelistExemptTarget: BoxModel {
    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    /// Box item type
    public var type: String
    private static var resourceType: String = "collaboration_whitelist_exempt_target"

    /// Identifier
    public let id: String
    /// The user that is exempted from the collaboration whitelist
    public let user: User?
    /// Mini representation of the enterprise.
    public let enterprise: Enterprise?
    /// When the target object was created.
    public let createdAt: Date?
    /// When the target object was last modified.
    public let modifiedAt: Date?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        guard let itemType = json["type"] as? String, itemType == CollaborationWhitelistExemptTarget.resourceType else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        rawData = json
        type = itemType
        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        user = try BoxJSONDecoder.optionalDecode(json: json, forKey: "user")
        enterprise = try BoxJSONDecoder.optionalDecode(json: json, forKey: "enterprise")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
    }
}
