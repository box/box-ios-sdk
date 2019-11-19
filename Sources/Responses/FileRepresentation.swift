//
//  FileRepresentation.swift
//  BoxSDK
//
//  Created by Daniel Cech on 01/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

public enum FileRepresentationHint: BoxEnum {

    /// The PDF representation
    case pdf
    /// Thumbnail image with resolution 320x320px.
    case thumbnail
    /// Image with resolution 1024x1024px.
    case imageMedium
    /// Image with resolution 2048x2048px.
    case imageLarge
    /// Extracted text from original document.
    case extractedText
    /// It is possible to use custom vale. See [representations documentation](https://developer.box.com/reference#representations).
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "[pdf]":
            self = .pdf
        case "[jpg?dimensions=320x320]":
            self = .thumbnail
        case "[jpg?dimensions=1024x1024][png?dimensions=1024x1024]":
            self = .imageMedium
        case "[jpg?dimensions=2048x2048][png?dimensions=2048x2048]":
            self = .imageLarge
        case "[extracted_text]":
            self = .extractedText
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .pdf:
            return "[pdf]"
        case .thumbnail:
            return "[jpg?dimensions=320x320]"
        case .imageMedium:
            return "[jpg?dimensions=1024x1024][png?dimensions=1024x1024]"
        case .imageLarge:
            return "[jpg?dimensions=2048x2048][png?dimensions=2048x2048]"
        case .extractedText:
            return "[extracted_text]"
        case let .customValue(userValue):
            return userValue
        }
    }
}

/// Digital assets created for files stored in Box.
public struct FileRepresentation: BoxInnerModel {

    /// An opaque URL template to the content.
    public let content: Content?
    /// An opaque URL which will return status information about the file.
    public let info: Info?
    /// A set of static properties to distinguish between subtypes of a given representation,
    /// for example, different sizes of jpg's. Each representation has its own set of properties.
    public let properties: [String: String]
    /// Status string
    public let status: Status?
    /// Usually the extension of the format, but occasionally a name of a standard (potentially de facto)
    /// format or a proprietary format that Box supports.
    public let representation: String?

    /// Contains an opaque URL template to the content, which follows RFC 6570.
    /// There is an asset_path variable that should be replaced with a valid path.
    /// Valid paths are different for each representation subtype.
    /// It may change over time and should not be hard-coded or cached.
    public struct Content: BoxInnerModel {
        /// An opaque URL template to the content.
        public let urlTemplate: String?
    }

    /// Contains an opaque URL which will return status information about the file.
    /// It may change over time and should not be hard-coded or cached.
    /// The response is the entries object from the array with all fields available.
    public struct Info: BoxInnerModel {
        /// An opaque URL which will return status information about the file.
        public let url: String?
    }

    public struct Status: BoxInnerModel {
        public let state: StatusEnum?
    }

    /// A string with one of the following values: 'none', 'pending', 'viewable', 'error' and 'success'.
    public enum StatusEnum: BoxEnum {
        /// Generating the representation needs to be manually triggered (see info.url note).
        case none
        /// Content is being generated but is not ready yet.
        case pending
        /// Similar to pending, though indicates that enough content is available to be useful.
        case viewable
        /// All of the content is available and complete.
        case success
        /// An error happened and this content is not available.
        case error
        /// A custom value not implemented in this version of SDK.
        case customValue(String)

        public init(_ value: String) {
            switch value {
            case "none":
                self = .none
            case "pending":
                self = .pending
            case "viewable":
                self = .viewable
            case "success":
                self = .success
            case "error":
                self = .error
            default:
                self = .customValue(value)
            }
        }

        public var description: String {

            switch self {
            case .none:
                return "none"
            case .pending:
                return "pending"
            case .viewable:
                return "viewable"
            case .success:
                return "success"
            case .error:
                return "error"
            case let .customValue(userValue):
                return userValue
            }
        }
    }
}
