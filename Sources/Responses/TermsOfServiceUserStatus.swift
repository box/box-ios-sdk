//
//  TermsOfServiceUserStatus.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 8/14/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

/// Represents a Terms of Service status for a given user.
public class TermsOfServiceUserStatus: BoxModel {

    // MARK: - BoxModel
    private static var resourceType: String = "terms_of_service_user_status"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties
    /// The ID of the user status object for the Terms of Service.
    public let id: String
    /// The Terms of Service this status is associated with.
    public let tos: TermsOfService?
    /// The user that is associated with the current status of the Terms of Service.
    public let user: User?
    /// Indicator as to whether or not the user has accepted the Terms of Service.
    public let isAccepted: Bool?
    /// The date the user status for the ToS was created.
    public let createdAt: Date?
    /// The date the user status for the ToS was modified.
    public let modifiedAt: Date?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == TermsOfServiceUserStatus.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [TermsOfServiceUserStatus.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        tos = try BoxJSONDecoder.optionalDecode(json: json, forKey: "tos")
        user = try BoxJSONDecoder.optionalDecode(json: json, forKey: "user")
        isAccepted = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_accepted")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
    }
}
