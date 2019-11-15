//
//  StoragePolicy.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/5/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

public class StoragePolicy: BoxModel {

    // MARK: - Properties
    public private(set) var rawData: [String: Any]
    private static var resourceType: String = "storage_policy"
    // Box item type
    public var type: String
    // Id of the storage policy
    public let id: String
    // Name for a storage zone
    public let name: String?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {

        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == StoragePolicy.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [StoragePolicy.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        name = try BoxJSONDecoder.optionalDecode(json: json, forKey: "name")
    }
}
