//
//  TaskItem.swift
//  BoxSDK
//
//  Created by Martina Stremeňová on 8/28/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

public enum TaskItem: BoxModel {

    // MARK: - BoxModel

    public var rawData: [String: Any] {
        switch self {
        case let .file(file):
            return file.rawData
        }
    }

    /// File with task assignment.
    case file(File)

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
        default:
            throw BoxCodingError(message: .valueMismatch(key: "type", value: type, acceptedValues: ["file"]))
        }
    }
}

extension TaskItem: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .file(file):
            return "file \(String(describing: file.name))"
        }
    }
}
