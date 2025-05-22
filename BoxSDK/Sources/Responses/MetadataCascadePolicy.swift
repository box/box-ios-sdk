//
//  MetadataCascadePolicy.swift
//  BoxSDK
//
//  Created by Daniel Cech on 04/09/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// A metadata object associated with a file or a folder.
public class MetadataCascadePolicy: BoxModel {
    // MARK: - Properties

    public private(set) var rawData: [String: Any]
    private static var resourceType: String = "metadata_cascade_policy"

    // MARK: - Properties

    /// Object type.
    public private(set) var type: String
    /// Identifier.
    public private(set) var id: String
    /// The enterprise that owns the policy.
    public private(set) var ownerEnterprise: Enterprise?
    /// Represent the parent of the policy and the metadata instance to cascade down.
    public private(set) var parent: Folder?
    /// The scope of the target instance that will be cascaded down. The scope & templateKey together identify
    /// the metadata on the folder that is to be cascaded down. Today, only 'global' and 'enterprise' scopes are supported.
    public private(set) var scope: MetadataScope?
    /// The template key of the target metadata template to cascade down. The scope & templateKey together identify
    /// the metadata on the folder that is to be cascaded down.
    public private(set) var templateKey: String?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == MetadataCascadePolicy.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [MetadataCascadePolicy.resourceType]))
        }

        type = itemType
        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        ownerEnterprise = try BoxJSONDecoder.optionalDecode(json: json, forKey: "owner_enterprise")
        parent = try BoxJSONDecoder.optionalDecode(json: json, forKey: "parent")
        scope = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "scope")
        templateKey = try BoxJSONDecoder.optionalDecode(json: json, forKey: "templateKey")
    }
}
