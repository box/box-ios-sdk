//
//  RetentionPolicyEntry.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremeňová on 9/2/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

public class RetentionPolicyEntry: BoxModel {
    private static var resourceType: String = "retention_policy"

    public private(set) var rawData: [String: Any]
    /// Box item type
    public var type: String

    /// Identifier
    public let id: String
    /// The name of the retention policy.
    public let name: String?

    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == RetentionPolicyEntry.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [RetentionPolicyEntry.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        name = try BoxJSONDecoder.optionalDecode(json: json, forKey: "name")
    }
}
