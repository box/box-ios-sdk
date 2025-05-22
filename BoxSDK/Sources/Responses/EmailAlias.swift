//
//  EmailAlias.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/14/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// User's email alias.
public class EmailAlias: BoxModel {
    // MARK: - BoxModel

    private static var resourceType: String = "email_alias"
    /// Type of Box item.
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let id: String
    /// Whether email alias is confirmed.
    public let isConfirmed: Bool?
    /// User's email address.
    public let email: String?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == EmailAlias.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [EmailAlias.resourceType]))
        }

        rawData = json
        type = itemType
        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        isConfirmed = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_confirmed")
        email = try BoxJSONDecoder.optionalDecode(json: json, forKey: "email")
    }
}
