//
//  MetadataObject.swift
//  BoxSDK
//
//  Created by Daniel Cech on 28/06/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Operations on a file metadata
public enum FileMetadataOperation {
    /// Adds new metadata path/value pair
    case add(path: String, value: String)
    /// Replaces metadata for path with a new value
    case replace(path: String, value: String)
    /// Tests expected metadata value for given path
    case test(path: String, value: String)
    /// Removes metadata for given path
    case remove(path: String)
    /// Moves metadata from original path to new path
    case move(from: String, path: String)
    /// Copies metadata from original path to new path
    case copy(from: String, path: String)

    /// Creates JSON dictionary representation of an operation option.
    ///
    /// - Returns: JSON dictionary representation of an operation option.
    public func json() -> [String: Any] {
        switch self {
        case let .add(path, value):
            return ["op": "add", "path": path, "value": value]
        case let .replace(path, value):
            return ["op": "replace", "path": path, "value": value]
        case let .test(path, value):
            return ["op": "test", "path": path, "value": value]
        case let .remove(path):
            return ["op": "remove", "path": path]
        case let .move(from, path):
            return ["op": "move", "from": from, "path": path]
        case let .copy(from, path):
            return ["op": "copy", "from": from, "path": path]
        }
    }
}

/// Operations on a folder metadata
public enum FolderMetadataOperation {
    /// Adds new metadata path/value pair
    case add(path: String, value: String)
    /// Replaces metadata for path with a new value
    case replace(path: String, value: String)
    /// Tests expected metadata value for given path
    case test(path: String, value: String)
    /// Removes metadata for given path
    case remove(path: String)

    /// Creates JSON dictionary representation of an operation option.
    ///
    /// - Returns: JSON dictionary representation of an operation option.
    public func json() -> [String: Any] {
        switch self {
        case let .add(path, value):
            return ["op": "add", "path": path, "value": value]
        case let .replace(path, value):
            return ["op": "replace", "path": path, "value": value]
        case let .test(path, value):
            return ["op": "test", "path": path, "value": value]
        case let .remove(path):
            return ["op": "remove", "path": path]
        }
    }
}

/// A metadata object associated with a file or a folder.
public class MetadataObject: BoxModel {
    // MARK: - Properties

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier.
    public private(set) var id: String?
    /// The key of the template.
    public private(set) var template: String?
    /// The scope of the object. global and enterprise scopes are supported. The global scope contains the properties template,
    /// while the enterprise scope pertains to custom templates within the enterprise.
    public private(set) var scope: String?
    /// The ID of the object the metadata object belongs to. Both file and folder objects are supported.
    public private(set) var parent: String?
    /// The version of the metadata object. Starts at 0 and increases every time a user-defined property is modified.
    public private(set) var version: Int?
    /// A unique identifier for the "type" of this instance.
    public private(set) var type: String?
    /// The last-known version of the template of the object.
    /// This is an internal system property and should not be used by a client application.
    public private(set) var typeVersion: Int?
    /// Custom value(s) defined by the template. These values also have a corresponding display name
    /// that are viewable in applications like the Box web application.
    public private(set) var keys: [String: Any] = [:]

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        for item in json {
            switch item.key {
            case "$id":
                id = try BoxJSONDecoder.optionalDecode(json: json, forKey: "$id")
            case "$template":
                template = try BoxJSONDecoder.optionalDecode(json: json, forKey: "$template")
            case "$scope":
                scope = try BoxJSONDecoder.optionalDecode(json: json, forKey: "$scope")
            case "$type":
                type = try BoxJSONDecoder.optionalDecode(json: json, forKey: "$type")
            case "$parent":
                parent = try BoxJSONDecoder.optionalDecode(json: json, forKey: "$parent")
            case "$version":
                version = try BoxJSONDecoder.optionalDecode(json: json, forKey: "$version")
            case "$typeVersion":
                typeVersion = try BoxJSONDecoder.optionalDecode(json: json, forKey: "$typeVersion")
            default:
                keys[item.key] = item.value
            }
        }
    }
}
