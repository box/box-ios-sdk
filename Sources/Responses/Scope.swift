//
//  Scope.swift
//  BoxSDK
//
//  Created by Abel Osorio on 3/29/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

// swiftlint:disable cyclomatic_complexity

/// Specifies permissions that define a token scope
public enum TokenScope: BoxEnum {

    /// Allow user to edit annotations (delete).
    case annotationEdit
    /// Allows user to view all users' annotations.
    case annotationViewAll
    /// Allows user to view their own annotations only.
    case annotationViewSelf
    /// Allows access to content in the folder tree based on user/file/token permissions.
    case baseExplorer
    /// Allows access to content in the folder tree based on user/file/token permissions.
    case basePicker
    /// Allows the user to preview the file, nothing else.
    case basePreview
    /// Allows the user to get basic file info needed for the sidebar.
    case baseSidebar
    /// Allows upload into the folder specific under "resource" of the Token Exchange request.
    case baseUpload
    /// Allows file/folders to be deleted.
    case itemDelete
    /// Allows files/folders contents to be downloaded.
    case itemDownload
    /// Automatically enables preview of the file, upon user click (requires Preview UI Element to be referenced).
    case itemPreview
    /// Allows files/folders to be renamed.
    case itemRename
    /// Allows sharing of resource specified under "resource" of the Token Exchange request.
    case itemShare
    /// Allows upload in the content picker.
    case itemUpload
    /// Custom permission that was not yet implemented in this version of SDK.
    case customValue(String)

    /// Initializer.
    ///
    /// - Parameter value: String representation of token scope
    public init(_ value: String) {
        switch value {
        case "annotation_edit":
            self = .annotationEdit
        case "annotation_view_all":
            self = .annotationViewAll
        case "annotation_view_self":
            self = .annotationViewSelf
        case "base_explorer":
            self = .baseExplorer
        case "base_picker":
            self = .basePicker
        case "base_preview":
            self = .basePreview
        case "base_sidebar":
            self = .baseSidebar
        case "base_upload":
            self = .baseUpload
        case "item_delete":
            self = .itemDelete
        case "item_download":
            self = .itemDownload
        case "item_preview":
            self = .itemPreview
        case "item_rename":
            self = .itemRename
        case "item_share":
            self = .itemShare
        case "item_upload":
            self = .itemUpload
        default:
            self = .customValue(value)
        }
    }

    /// String representation of token scope
    public var description: String {

        switch self {
        case .annotationEdit:
            return "annotation_edit"
        case .annotationViewAll:
            return "annotation_view_all"
        case .annotationViewSelf:
            return "annotation_view_self"
        case .baseExplorer:
            return "base_explorer"
        case .basePicker:
            return "base_picker"
        case .basePreview:
            return "base_preview"
        case .baseSidebar:
            return "base_sidebar"
        case .baseUpload:
            return "base_upload"
        case .itemDelete:
            return "item_delete"
        case .itemDownload:
            return "item_download"
        case .itemPreview:
            return "item_preview"
        case .itemRename:
            return "item_rename"
        case .itemShare:
            return "item_share"
        case .itemUpload:
            return "item_upload"
        case let .customValue(value):
            return value
        }
    }
}

extension TokenScope: Hashable {}

/// Permission scope for a token.
public class Scope: BoxModel {
    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Scope permission
    public let scope: String?
    /// The file scope is applied to
    public let object: File?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        scope = try BoxJSONDecoder.optionalDecode(json: json, forKey: "scope")
        object = try BoxJSONDecoder.optionalDecode(json: json, forKey: "object")
    }
}
