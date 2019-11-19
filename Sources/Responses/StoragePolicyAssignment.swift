//
//  StoragePolicyAssignment.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/5/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

public class StoragePolicyAssignment: BoxModel {

    /// Enterprise storage policy is assigned to
    public struct AssignedTo: BoxInnerModel {
        public let type: String
        public let id: String
    }

    // MARK: - Properties
    public private(set) var rawData: [String: Any]
    private static var resourceType: String = "storage_policy_assignment"
    // Box item type
    public var type: String
    // Id of the storage policy assignment
    public let id: String
    // Storage policy
    public let storagePolicy: StoragePolicy?
    // Enterprise the storage policy is assigned to
    public let assignedTo: AssignedTo?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {

        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == StoragePolicyAssignment.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [StoragePolicyAssignment.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        storagePolicy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "storage_policy")
        assignedTo = try BoxJSONDecoder.optionalDecode(json: json, forKey: "assigned_to")
    }
}
