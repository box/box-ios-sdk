//
//  SearchResult.swift
//  BoxSDK-iOS
//
//  Created by Skye Free on 2/9/21.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

/// Files, folders and web links that matched the search query, including the additional information about any shared links through which the item has been shared with the user.
public class SearchResult: BoxModel {

    // MARK: - BoxModel

    private static var resourceType: String = "search_result"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// The optional shared link through which the user has access to this item.
    /// This value is only returned for items for which the user has recently accessed the file through a shared link. For all other items this value will return nil.
    public let accessibleViaSharedLink: URL?
    /// The file, folder or web link that matched the search query.
    public let item: FolderItem

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == SearchResult.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [SearchResult.resourceType]))
        }

        rawData = json
        type = itemType

        accessibleViaSharedLink = try BoxJSONDecoder.optionalDecodeURL(json: json, forKey: "accessible_via_shared_link")
        item = try BoxJSONDecoder.decode(json: json, forKey: "item")
    }
}
