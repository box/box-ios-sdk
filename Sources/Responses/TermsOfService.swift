//
//  TermsOfService.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 8/14/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

/// The Terms of Service allows Box Admins to configure a custom ToS indicating to users.
/// Users can accept/ re-accept for custom applications.
public class TermsOfService: BoxModel {

    // MARK: - BoxModel
    private static var resourceType: String = "terms_of_service"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties
    public let id: String
    /// An enum indicating whether the ToS is currently active or inactive.
    public let status: TermsOfServiceStatus?
    /// A mini Box enterprise object that the ToS is associated with.
    public let enterprise: Enterprise?
    /// The scope of the ToS.
    public let tosType: TermsOfServiceType?
    /// The agreement of the ToS specified for the user in the custom application.
    public let text: String?
    /// The date created at for the ToS.
    public let createdAt: Date?
    /// The date modified at for the ToS.
    public let modifiedAt: Date?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == TermsOfService.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [TermsOfService.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        status = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "status")
        enterprise = try BoxJSONDecoder.optionalDecode(json: json, forKey: "enterprise")
        tosType = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "tos_type")
        text = try BoxJSONDecoder.optionalDecode(json: json, forKey: "text")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
    }
}
