//
//  CollaborationWhitelistEntry.swift
//  BoxSDK
//
//  Created by Daniel Cech on 8/29/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

public enum CollaborationDirection: BoxEnum {
    /// Inbound collaboration direction
    case inbound
    /// Outbound collaboration direction
    case outbound
    /// Bi-directional collaboration
    case both
    /// A custom scope for metadata template.
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "inbound":
            self = .inbound
        case "outbound":
            self = .outbound
        case "both":
            self = .both
        default:
            self = .customValue(value)
        }
    }

    public var description: String {

        switch self {
        case .inbound:
            return "inbound"
        case .outbound:
            return "outbound"
        case .both:
            return "both"
        case let .customValue(value):
            return value
        }
    }
}

/// A whitelisted domain in the enterprise. This record consists of both direction
/// (inbound, outbound, or both) and a domain (box.com).
public class CollaborationWhitelistEntry: BoxModel {
    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    /// Box item type
    public var type: String
    private static var resourceType: String = "collaboration_whitelist_entry"

    /// Identifier
    public let id: String
    /// The URL domain name
    public let domain: String?
    /// Direction of colaboration - can be inbound, outbound or both
    public let direction: CollaborationDirection?
    /// Mini representation of the user’s enterprise.
    public let enterprise: Enterprise?
    /// When the collaboration object was created.
    public let createdAt: Date?
    /// When the collaboration object was last modified.
    public let modifiedAt: Date?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        guard let itemType = json["type"] as? String, itemType == CollaborationWhitelistEntry.resourceType else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        rawData = json
        type = itemType
        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        domain = try BoxJSONDecoder.optionalDecode(json: json, forKey: "domain")
        direction = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "direction")
        enterprise = try BoxJSONDecoder.optionalDecode(json: json, forKey: "enterprise")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
    }
}
