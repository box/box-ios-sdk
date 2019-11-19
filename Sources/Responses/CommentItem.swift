//
//  CommentItem.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 5/30/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Item a comment was placed on
public enum CommentItem: BoxModel {
    // MARK: - BoxModel

    public var rawData: [String: Any] {
        switch self {
        case let .comment(comment):
            return comment.rawData
        case let .file(file):
            return file.rawData
        }
    }

    case file(File)
    case comment(Comment)

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public init(json: [String: Any]) throws {

        guard let type = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }
        switch type {
        case "file":
            let file = try File(json: json)
            self = .file(file)
        case "comment":
            let comment = try Comment(json: json)
            self = .comment(comment)
        default:
            throw BoxCodingError(message: .valueMismatch(key: "type", value: type, acceptedValues: ["file", "comment"]))
        }
    }
}

extension CommentItem: CustomDebugStringConvertible {
    /// Debug description of an object
    public var debugDescription: String {
        switch self {
        case let .file(file):
            return "file \(String(describing: file.name))"
        case let .comment(comment):
            return "comment \(String(describing: comment.id))"
        }
    }
}
