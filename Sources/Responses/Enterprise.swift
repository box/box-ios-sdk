//
//  Enterprise.swift
//  BoxSDK
//
//  Created by Abel Osorio on 3/29/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Enterprise
public class Enterprise: BoxModel {
    // MARK: - BoxModel

    private static var resourceType: String = "enterprise"
    /// Type of Box item.
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let id: String
    /// Enterprise name
    public let name: String?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == Enterprise.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [Enterprise.resourceType]))
        }

        rawData = json
        type = itemType
        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        name = try BoxJSONDecoder.optionalDecode(json: json, forKey: "name")
    }
}
