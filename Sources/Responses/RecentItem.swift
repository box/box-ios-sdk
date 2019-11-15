//
//  RecentItem.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 8/26/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

public class RecentItem: BoxModel {

    /// Interaction type with item
    public enum InteractionType: BoxEnum {
        /// Item was previewd
        case itemPreview
        /// Item was uploaded
        case itemUpload
        /// Item was commented on
        case itemComment
        /// Item was opened
        case itemOpen
        /// Item was modified
        case itemModify
        /// Custom value for enum values not yet implemented in the SDK
        case customValue(String)

        public init(_ value: String) {
            switch value {
            case "item_preview":
                self = .itemPreview
            case "item_upload":
                self = .itemUpload
            case "item_comment":
                self = .itemComment
            case "item_open":
                self = .itemOpen
            case "item_modify":
                self = .itemModify
            default:
                self = .customValue(value)
            }
        }

        public var description: String {
            switch self {
            case .itemPreview:
                return "item_preview"
            case .itemUpload:
                return "item_upload"
            case .itemComment:
                return "item_comment"
            case .itemOpen:
                return "item_open"
            case .itemModify:
                return "item_modify"
            case let .customValue(value):
                return value
            }
        }
    }

    // MARK: - Properties

    public private(set) var rawData: [String: Any]
    private static var resourceType: String = "recent_item"
    // Box item type
    public var type: String
    // Type of interation
    public let interactionType: InteractionType
    // Timestamp of the interactions
    public let interactedAt: Date
    // The item
    public let item: File
    // Shared link of interaction
    public let interactionSharedLink: String?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {

        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == RecentItem.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [RecentItem.resourceType]))
        }

        rawData = json
        type = itemType

        interactionType = try BoxJSONDecoder.decodeEnum(json: json, forKey: "interaction_type")
        interactedAt = try BoxJSONDecoder.decodeDate(json: json, forKey: "interacted_at")
        item = try BoxJSONDecoder.decode(json: json, forKey: "item")
        interactionSharedLink = try BoxJSONDecoder.optionalDecode(json: json, forKey: "interaction_shared_link")
    }
}
