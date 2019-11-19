//
//  UploadPart.swift
//  BoxSDK
//
//  Created by Daniel Cech on 8/15/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Description of uploaded part
public struct UploadPartDescription: BoxModel {
    public let partId: String
    public let offset: Int
    public let size: Int
    public let sha1: String?
}

/// Extension for the description of the upload part
public extension UploadPartDescription {
    /// Initializer
    /// - Parameter json: The json representation of the description of the upload part
    init(json: [String: Any]) throws {
        partId = try BoxJSONDecoder.decode(json: json, forKey: "part_id")
        offset = try BoxJSONDecoder.decode(json: json, forKey: "offset")
        size = try BoxJSONDecoder.decode(json: json, forKey: "size")
        sha1 = try BoxJSONDecoder.optionalDecode(json: json, forKey: "sha1")
    }

    /// The upload part description's raw data
    var rawData: [String: Any] {
        return [:]
    }

    /// Get the upload part description in JSON
    func jsonRepresentation() -> [String: Any] {
        var json = [String: Any]()
        json["part_id"] = partId
        json["offset"] = offset
        json["size"] = size
        json["sha1"] = sha1
        return json
    }
}

/// Object representing part of chunked upload.
public class UploadPart: BoxModel {

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Part description object
    public let part: UploadPartDescription

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        part = try BoxJSONDecoder.decode(json: json, forKey: "part")
    }
}
