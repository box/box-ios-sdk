//
//  BoxCollection.swift
//  BoxSDK
//
//  Created by Daniel Cech on 03/06/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Collections contain information about the items contained inside of them, including files and folders.
/// The only collection available is the “Favorites” collection. The contents of the collection are discovered
/// in a similar way in which the contents of a folder are discovered.
public class BoxCollection: BoxModel {

    // MARK: - Properties

    /// Box item type - should be collection.
    public var type: String
    /// Identifier
    public let id: String
    /// Name of the collection
    public let name: String?
    /// The type of the collection. This is used to determine the proper visual treatment for collections.
    /// The only collection type is favorites.
    public let collectionType: String?
    public private(set) var rawData: [String: Any]

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }
        rawData = json
        type = itemType
        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        name = try BoxJSONDecoder.optionalDecode(json: json, forKey: "name")
        collectionType = try BoxJSONDecoder.optionalDecode(json: json, forKey: "collection_type")
    }
}
