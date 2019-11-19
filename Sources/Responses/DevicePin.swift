//
//  DevicePin.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 8/27/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

// Contain a device pin that allows the enterprise to control devices connecting to it.
public class DevicePin: BoxModel {

    // MARK: - BoxModel

    private static var resourceType: String = "device_pinner"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// The ID of the device pinner object.
    public let id: String
    // The user that the device pin belongs to.
    public let ownedBy: User?
    // The type of device being pinned.
    public let productName: String?
    // The time the device pin was created.
    public let createdAt: Date?
    // The time the device pin was modified.
    public let modifiedAt: Date?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {

        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == DevicePin.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [DevicePin.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        ownedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "owned_by")
        productName = try BoxJSONDecoder.optionalDecode(json: json, forKey: "product_name")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
    }
}
