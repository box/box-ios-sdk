//
// FileRequest.swift
// BoxSDK-iOS
//
// Created by Artur Jankowski on 09/08/2022.
// Copyright © Box. All rights reserved.
//

import Foundation

/// The status of the file request.
public enum FileRequestStatus: BoxEnum {
    /// The file request can accept new submissions.
    case active
    /// The file request can't accept new submissions, and any visitor to the file request URL will receive a `HTTP 404` status code.
    case inactive
    /// Custom value for enum values not yet implemented in the SDK
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "active":
            self = .active
        case "inactive":
            self = .inactive
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .active:
            return "active"
        case .inactive:
            return "inactive"
        case let .customValue(value):
            return value
        }
    }
}

// A standard representation of a file request, as returned from any file request API endpoints by default.
public final class FileRequest: BoxModel {

    // MARK: - BoxModel

    private static var resourceType: String = "file_request"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// The unique identifier for this file request.
    public let id: String
    /// The title of file request. This is shown in the Box UI to users uploading files.
    public let title: String?
    /// The optional description of this file request. This is shown in the Box UI to users uploading files.
    public let description: String?
    /// The status of the file request.
    public let status: FileRequestStatus?
    /// Whether a file request submitter is required to provide their email address.  When this setting is set to true, the Box UI will show an email field on the file request form.
    public let isEmailRequired: Bool?
    /// Whether a file request submitter is required to provide a description of the files they are submitting.
    /// When this setting is set to true, the Box UI will show a description field on the file request form.
    public let isDescriptionRequired: Bool?
    /// The date after which a file request will no longer accept new submissions.  After this date, the `status` will automatically be set to `inactive`.
    public let expiresAt: Date?
    /// The folder that this file request is associated with. Files submitted through the file request form will be uploaded to this folder.
    public let folder: Folder
    /// The generated URL for this file request. This URL can be shared with users to let them upload files to the associated folder.
    public let url: String?
    /// The HTTP `etag` of this file. This can be used in combination with the `If-Match` header when updating a file request.
    /// By providing that header, a change will only be performed on the  file request if the `etag` on the file request still matches the `etag` provided in the `If-Match` header.
    public let etag: String?
    /// The user who created this file request.
    public let createdBy: User?
    /// The date and time when the file request was created.
    public let createdAt: Date
    /// The user who last modified this file request.
    public let updatedBy: User?
    /// The date and time when the file request was last updated.
    public let updatedAt: Date

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == FileRequest.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [FileRequest.resourceType]))
        }

        type = itemType
        rawData = json
        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        title = try BoxJSONDecoder.optionalDecode(json: json, forKey: "title")
        description = try BoxJSONDecoder.optionalDecode(json: json, forKey: "description")
        status = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "status")
        isEmailRequired = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_email_required")
        isDescriptionRequired = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_description_required")
        expiresAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "expires_at")
        folder = try BoxJSONDecoder.decode(json: json, forKey: "folder")
        url = try BoxJSONDecoder.optionalDecode(json: json, forKey: "url")
        etag = try BoxJSONDecoder.optionalDecode(json: json, forKey: "etag")
        createdBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "created_by")
        createdAt = try BoxJSONDecoder.decodeDate(json: json, forKey: "created_at")
        updatedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "updated_by")
        updatedAt = try BoxJSONDecoder.decodeDate(json: json, forKey: "updated_at")
    }
}
