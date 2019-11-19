//
//  UploadSession.swift
//  BoxSDK
//
//  Created by Daniel Cech on 8/15/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Session object for chunked upload.
public class UploadSession: BoxModel {

    /// Internal struct containing URLs for upload session manipulation
    public struct UploadSessionEndpoints: BoxInnerModel {
        public let listParts: URL?
        public let commit: URL?
        public let logEvent: URL?
        public let uploadPart: URL?
        public let status: URL?
        public let abort: URL?
    }

    public private(set) var rawData: [String: Any]
    private static var resourceType: String = "upload_session"
    /// Box item type
    public var type: String

    // MARK: - Properties

    /// Identifier
    public let id: String
    /// Count of uploaded parts
    public let totalParts: Int
    /// Size of uploaded part. Each part’s size must be exactly equal in size to the part size specified
    /// in the response to the create session request. The last part of the file is exempt from this restriction and is allowed to be smaller.
    public let partSize: Int
    /// Number of parts processed
    public let numPartsProcessed: Int
    /// The validity end of this session
    public let sessionExpiresAt: Date
    /// Set of URL for upload session management
    public let sessionEndpoints: UploadSessionEndpoints

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {

        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == UploadSession.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [UploadSession.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        totalParts = try BoxJSONDecoder.decode(json: json, forKey: "total_parts")
        partSize = try BoxJSONDecoder.decode(json: json, forKey: "part_size")
        numPartsProcessed = try BoxJSONDecoder.decode(json: json, forKey: "num_parts_processed")
        sessionExpiresAt = try BoxJSONDecoder.decodeDate(json: json, forKey: "session_expires_at")
        sessionEndpoints = try BoxJSONDecoder.decode(json: json, forKey: "session_endpoints")
    }
}
